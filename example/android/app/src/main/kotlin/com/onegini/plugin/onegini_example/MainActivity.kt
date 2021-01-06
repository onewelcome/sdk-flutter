package com.onegini.plugin.onegini_example

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.helpers.RegistrationHelper
import com.onegini.plugin.onegini_example.providers.TwoWayOtpIdentityProvider
import com.onegini.plugin.onegini_example.providers.TwoWayOtpRegistrationAction
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

object SecurityController {
    const val debugDetection = false
    const val rootDetection = false
    const val debugLogs = true
}


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
