package com.onegini.plugin.onegini_example

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.onegini.plugin.onegini.RegistrationHelper
import com.onegini.plugin.onegini.StorageIdentityProviders
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), MethodChannel.MethodCallHandler {


    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        StorageIdentityProviders.oneginiCustomIdentityProviders.add(TwoWayOtpIdentityProvider(this.applicationContext))


    }
    private val CHANNEL = "example"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
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
    }

}
