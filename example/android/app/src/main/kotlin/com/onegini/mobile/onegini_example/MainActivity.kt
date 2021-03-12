package com.onegini.mobile.onegini_example

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.onegini_example.providers.TwoWayOtpIdentityProvider
import com.onegini.mobile.onegini_example.providers.TwoWayOtpRegistrationAction
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {


    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val customProviders = mutableListOf<OneginiCustomIdentityProvider>()
        customProviders.add(TwoWayOtpIdentityProvider(this.applicationContext))
        OneginiSDK.init(context,
                OneginiConfigModel(),
                SecurityController::class.java,
                oneginiCustomIdentityProviders = customProviders)
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
        if (call.method == "otpOk") {
            val password = call.argument<String>("password")
            TwoWayOtpRegistrationAction.CALLBACK?.returnSuccess(password)
        }
        if (call.method == "otpCancel") {
            TwoWayOtpRegistrationAction.CALLBACK?.returnError(Exception("Registration canceled"))
        }
    }
}
