package com.onegini.plugin.onegini_example

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.constants.Constants
import com.onegini.plugin.onegini.helpers.RegistrationHelper
import com.onegini.plugin.onegini_example.providers.TwoWayOtpIdentityProvider
import com.onegini.plugin.onegini_example.providers.TwoWayOtpRegistrationAction
import com.onegini.plugin.onegini_example.service.AnonymousService
import com.onegini.plugin.onegini_example.service.ImplicitUserService
import com.onegini.plugin.onegini_example.service.UserService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception


class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {


    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        OneginiSDK.addCustomIdentityProvider(TwoWayOtpIdentityProvider(this.applicationContext))
        OneginiSDK.setOneginiClientConfigModel(OneginiConfigModel())
        OneginiSDK.setSecurityController(SecurityController::class.java)
        OneginiSDK.setReadTimeout(25)
        OneginiSDK.setConnectionTimeout(5)


    }
    private val channelName = "example"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "exemple_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                EventStorage.setEventSink(events)
            }
            override fun onCancel(arguments: Any?) {

            }

        })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null)
            RegistrationHelper.handleRegistrationCallback(intent.data)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method == "otpOk"){
            val password = call.argument<String>("password")
            TwoWayOtpRegistrationAction.CALLBACK?.returnSuccess(password)
        }
        if(call.method == "otpCancel"){
            TwoWayOtpRegistrationAction.CALLBACK?.returnError(Exception("Registration canceled"))
        }
        if (call.method == Constants.METHOD_GET_APPLICATION_DETAILS) {
            authenticateDevice(result)
        }
        if (call.method == Constants.METHOD_GET_CLIENT_RESOURCE) {
            getClientResource(result)
        }
        if (call.method == Constants.METHOD_GET_IMPLICIT_USER_DETAILS) {
            getImplicitUserDetails(result)
        }
        
    }


    private fun authenticateDevice(result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context)?.deviceClient?.authenticateDevice(arrayOf("application-details"), object : OneginiDeviceAuthenticationHandler {
            @SuppressLint("CheckResult")
            override fun onSuccess() {
                AnonymousService(activity).applicationDetails
                        ?.subscribe { details -> result.success(Gson().toJson(details)) }
            }

            override fun onError(error: OneginiDeviceAuthenticationError) {
                result.error(error.errorType.toString(), error.message, error.errorDetails)
            }
        }
        )
    }

    private fun getImplicitUserDetails(result: MethodChannel.Result) {
        val userProfile = OneginiSDK.getOneginiClient(context)?.userClient?.authenticatedUserProfile
                ?: return
        //todo if need show error use OneginiEventSender
        OneginiSDK.getOneginiClient(context)?.userClient
                ?.authenticateUserImplicitly(userProfile, arrayOf("read"), object : OneginiImplicitAuthenticationHandler {
                    @SuppressLint("CheckResult")
                    override fun onSuccess(profile: UserProfile) {
                        ImplicitUserService(activity).userDetails?.subscribe({ result.success(it.toString()) }, {
                            result.error("", it.message, it.cause)
                        })

                    }

                    override fun onError(error: OneginiImplicitTokenRequestError) {
                        result.error(error.errorType.toString(), error.message, error.cause)
                    }
                })
    }
    
    @SuppressLint("CheckResult")
    private fun getClientResource(result: MethodChannel.Result) {
        UserService(activity).devices?.subscribe({
            result.success(Gson().toJson(it))
        }, { result.error("", it.message, it.cause) })
    }

}
