package com.onegini.plugin.onegini

import android.app.Activity
import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.*
import com.onegini.mobile.sdk.android.handlers.error.*
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError.DeregistrationErrorType
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.handlers.CreatePinRequestHandler
import com.onegini.plugin.onegini.util.DeregistrationUtil
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
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        if (call.method == "startApp") {
            Log.d("Start_app", "START APP")
            val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(context)!!
            oneginiClient.start(object : OneginiInitializationHandler {
                override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                    result.success(true)
                }

                override fun onError(error: OneginiInitializationError?) {
                    Log.d("Start_app", error?.message!!)
                    print(error)
                }
            })
        }
        if (call.method == "getApplicationDetails") {
            authenticateDevice(result)
        }
        if (call.method == "getClientResource") {
            getClientResource(result)
        }
        if (call.method == "getImplicitUserDetails") {
            getImplicitUserDetails(result)
        }
        if (call.method == "registration") {
            registerUser(null, result)
        }
        if (call.method == "sendPin") {
            val pin = call.argument<String>("pin")
            CreatePinRequestHandler.CALLBACK?.onPinProvided(pin?.toCharArray())
        }
        if (call.method == "logOut") {
            logOut(result)
        }
        if (call.method == "deregisterUser") {
            deregisterUser(result)
        }
        if (call.method == "registrationCustomIdentityProvider") {
            val identityProviders = OneginiSDK.getOneginiClient(context)!!.userClient.identityProviders
            for (identityProvider in identityProviders) {
                Log.v("provider", "${identityProvider.id}  ${identityProvider.name}")
//                if(identityProvider.id == "2-way-otp-api"){
//                    registerUser(identityProvider,result)
//                }
            }
        }

    }

    private fun getClientResource(result: Result) {
        UserService(activity).devices.subscribe { response ->
           Toast.makeText(context,"size -> ${response.devices.size} \n " +
                   "details -> ${response.devices[0].deviceFullInfo}",Toast.LENGTH_SHORT).show()
        }

    }


    private fun getImplicitUserDetails(result: Result) {
        val userProfile = OneginiSDK.getOneginiClient(context)?.userClient?.authenticatedUserProfile
        if (userProfile == null) {
            Toast.makeText(context, "userProfile == null", Toast.LENGTH_SHORT).show()
            return
        }
        OneginiSDK.getOneginiClient(context)!!.userClient
                .authenticateUserImplicitly(userProfile, arrayOf("read"), object : OneginiImplicitAuthenticationHandler {
                    override fun onSuccess(profile: UserProfile) {
                        ImplicitUserService(activity).userDetails.subscribe({ Toast.makeText(context,"decorated user id => $it",Toast.LENGTH_SHORT).show() }, {
                            Log.v("error", it.message ?: "")
                        })
                    }

                    override fun onError(error: OneginiImplicitTokenRequestError) {

                    }
                })
    }

    private fun logOut(result: Result) {
        OneginiSDK.getOneginiClient(context)?.userClient?.logout(object : OneginiLogoutHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiLogoutError?) {
                result.error("0", error?.message, error?.errorDetails)
            }
        })
    }

    private fun authenticateDevice(result: Result) {
        OneginiSDK.getOneginiClient(context)?.deviceClient?.authenticateDevice(arrayOf("application-details"), object : OneginiDeviceAuthenticationHandler {
            override fun onSuccess() {
                AnonymousService(activity).applicationDetails
                        .subscribe { details -> Toast.makeText(context, "version -> ${details.applicationVersion}" +
                                " \n platform -> ${details.applicationPlatform}" +
                                " \n identifier -> ${details.applicationIdentifier}", Toast.LENGTH_SHORT).show() }
            }

            override fun onError(error: OneginiDeviceAuthenticationError) {
                result.error("0", error.message, error.errorDetails)
            }
        }
        )
    }

    /**
     * Start registration / LogIn flow
     * when [RegistrationRequestHandler] handled callback, check method [startPinCreation] in [CreatePinRequestHandler]
     */
    private fun registerUser(identityProvider: OneginiIdentityProvider?, result: Result) {
        RegistrationHelper.registerUser(context, identityProvider, object : OneginiRegistrationHandler {
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
                result.error(errorType.toString(), errorMessage ?: "", null)
            }
        })
    }


    private fun deregisterUser(result: Result) {

        val userProfile = OneginiSDK.getOneginiClient(context)?.userClient?.authenticatedUserProfile
        if (userProfile == null) {
            Toast.makeText(context, "userProfile == null", Toast.LENGTH_SHORT).show()
            return
        }

        DeregistrationUtil(context).onUserDeregistered(userProfile)
        OneginiSDK.getOneginiClient(context)?.userClient?.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
                onUserDeregistrationError(oneginiDeregistrationError)
                result.success(false)
            }

        }
        )

    }


    private fun onUserDeregistrationError(oneginiDeregistrationError: OneginiDeregistrationError) {
        @DeregistrationErrorType val errorType = oneginiDeregistrationError.errorType
        if (errorType == OneginiDeregistrationError.DEVICE_DEREGISTERED) {
            DeregistrationUtil(context).onDeviceDeregistered()
        }
        Toast.makeText(context, "Deregistration error: " + oneginiDeregistrationError.message, Toast.LENGTH_SHORT).show()
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
