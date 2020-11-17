package com.onegini.plugin.onegini

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
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
    private lateinit var context: Context
    private lateinit var activity: Activity


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(this)
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
        if (call.method == "getResource") {
            authenticateDevice(activity, result)
        }
        if (call.method == "registration") {
            registerUser(null, result)
        }
    }

  private fun authenticateDevice(activity: Activity, result: MethodChannel.Result) {
    OneginiSDK.getOneginiClient(context)?.deviceClient?.authenticateDevice(arrayOf("application-details"), object : OneginiDeviceAuthenticationHandler {
      override fun onSuccess() {
        AnonymousService(activity).applicationDetails
                .subscribe { device -> result.success("") }
      }

      override fun onError(error: OneginiDeviceAuthenticationError) {

      }
    }
    )
  }

  /**
   * Start registration / LogIn flow
   * when [RegistrationRequestHandler] handled callback, check method [startPinCreation] in [CreatePinRequestHandler]
   */
  private fun registerUser(identityProviderId: String?, result: MethodChannel.Result) {
    //todo this identityProviderId can be use later
    RegistrationHelper.registerUser(context, null, object : OneginiRegistrationHandler {
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
