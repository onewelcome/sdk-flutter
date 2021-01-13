package com.onegini.plugin.onegini

import android.app.Activity
import android.content.Context
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.*
import com.onegini.mobile.sdk.android.handlers.error.*
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.constants.Constants
import com.onegini.plugin.onegini.handlers.CreatePinRequestHandler
import com.onegini.plugin.onegini.handlers.PinAuthenticationRequestHandler
import com.onegini.plugin.onegini.helpers.OneginiEventsSender
import com.onegini.plugin.onegini.helpers.RegistrationHelper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context
    private lateinit var activity: Activity


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "onegini_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                OneginiEventsSender.setEventSink(events)
            }

            override fun onCancel(arguments: Any?) {

            }

        })
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == Constants.METHOD_GET_PLATFORM_VERSION) {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        if (call.method == Constants.METHOD_START_APP) {
            Log.d("Start_app", "START APP")
            val oneginiClient: OneginiClient? = OneginiSDK.getOneginiClient(context)
            oneginiClient?.start(object : OneginiInitializationHandler {
                override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                    result.success(Gson().toJson(removedUserProfiles))
                }

                override fun onError(error: OneginiInitializationError?) {
                    result.error(error?.errorType.toString(),error?.message,error?.errorDetails)
                }
            })
        }
        if (call.method == Constants.METHOD_REGISTRATION) {
            val scopes = call.argument<String>("scopes")!!
            registerUser(null,arrayOf(scopes),result)
        }
        if (call.method == Constants.METHOD_SEND_PIN) {
            val pin = call.argument<String>("pin")
            val auth = call.argument<Boolean>("isAuth")
            if(auth !=null && auth){
                PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin?.toCharArray())
            }else{
                CreatePinRequestHandler.CALLBACK?.onPinProvided(pin?.toCharArray())
            }

        }
        if(call.method == Constants.METHOD_PIN_AUTHENTICATION){
            authenticateUser(null,result)
        }
        if (call.method == Constants.METHOD_SINGLE_SIGN_ON) {
            startSingleSignOn(result)
        }
        if (call.method == Constants.METHOD_LOG_OUT) {
            logOut(result)
        }
        if (call.method == Constants.METHOD_DEREGISTER_USER) {
            deregisterUser(result)
        }
        if (call.method == Constants.METHOD_GET_IDENTITY_PROVIDERS) {
            val gson = GsonBuilder().serializeNulls().create()
            val identityProviders = OneginiSDK.getOneginiClient(context)?.userClient?.identityProviders
            val providers: ArrayList<Map<String, String>> = ArrayList()
            if (identityProviders != null)
                for (identityProvider in identityProviders) {
                    val map = mutableMapOf<String, String>()
                    map["id"] = identityProvider.id
                    map["name"] = identityProvider.name
                    providers.add(map)
                }
            result.success(gson.toJson(providers))
        }
        if (call.method == Constants.METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER) {
            val identityProviderId = call.argument<String>("identityProviderId")
            val scopes = call.argument<String>("scopes")!!
            val identityProviders = OneginiSDK.getOneginiClient(context)?.userClient?.identityProviders
            if (identityProviders != null)
                for (identityProvider in identityProviders) {
                    if (identityProvider.id == identityProviderId) {
                        registerUser(identityProvider, arrayOf(scopes),result)
                        break
                    }
                }
        }

    }




    private fun authenticateUser(profileId: String?, result: Result) {
        val userProfile = OneginiSDK.getOneginiClient(context)?.userClient?.userProfiles?.first()
        if(userProfile == null) {
            result.error("0","User profile is null","")
            return
        }
        Log.v("USER AUTH PROFILE",userProfile.profileId)
        OneginiSDK.getOneginiClient(context)?.userClient?.authenticateUser(userProfile, object : OneginiAuthenticationHandler {
            override fun onSuccess(userProfile: UserProfile?, customInfo: CustomInfo?) {
                if (userProfile != null)
                    result.success(userProfile.profileId)
            }

            override fun onError(error: OneginiAuthenticationError) {
                result.error(error.errorType.toString(), error.message ?: "", error.errorDetails)
            }
        })
    }



    private fun logOut(result: Result) {
        OneginiSDK.getOneginiClient(context)?.userClient?.logout(object : OneginiLogoutHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiLogoutError?) {
                result.error(error?.errorType.toString(), error?.message, error?.errorDetails)
            }
        })
    }



    /**
     * Start registration / LogIn flow
     * when RegistrationRequestHandler handled callback, check method startPinCreation in [CreatePinRequestHandler]
     */
    private fun registerUser(identityProvider: OneginiIdentityProvider?, scopes: Array<String>,result: Result) {
        RegistrationHelper.registerUser(context, identityProvider,scopes ,object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile?, customInfo: CustomInfo?) {
                if (userProfile != null)
                    result.success(userProfile.profileId)
            }

            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                val errorType = oneginiRegistrationError.errorType
                var errorMessage: String? = RegistrationHelper.getErrorMessageByCode(errorType)
                if (errorMessage == null) {
                    errorMessage = oneginiRegistrationError.message
                }
                result.error(errorType.toString(), errorMessage ?: "", oneginiRegistrationError.errorDetails)
            }
        })
    }


    private fun deregisterUser(result: Result) {

        val userProfile = OneginiSDK.getOneginiClient(context)?.userClient?.authenticatedUserProfile
                ?: return
        //todo DeregistrationUtil(context).onUserDeregistered(userProfile)
        OneginiSDK.getOneginiClient(context)?.userClient?.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
                result.error(oneginiDeregistrationError.errorType.toString(), oneginiDeregistrationError.message, oneginiDeregistrationError.errorDetails)
            }

        }
        )

    }

    private fun startSingleSignOn(result: Result) {
        val targetUri: Uri = Uri.parse("https://login-mobile.test.onegini.com/personal/dashboard")
        val oneginiClient = OneginiSDK.getOneginiClient(context)
        oneginiClient?.userClient?.getAppToWebSingleSignOn(targetUri, object : OneginiAppToWebSingleSignOnHandler {
            override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                 result.success(Gson().toJson(oneginiAppToWebSingleSignOn))
            }

            override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                result.error(oneginiSingleSignOnError.errorType.toString(), oneginiSingleSignOnError.message, Gson().toJson(oneginiSingleSignOnError.errorDetails))
            }

        })
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

}
