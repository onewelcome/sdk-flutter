package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.module.FlutterOneWelcomeSdkModule
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceMethodApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject


/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, PigeonInterface() {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    @Inject
    lateinit var onMethodCallMapper: OnMethodCallMapper
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // Pigeon setup
        UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)
        ResourceMethodApi.setUp(flutterPluginBinding.binaryMessenger, this)

        val component = DaggerFlutterOneWelcomeSdkComponent.builder()
            .flutterOneWelcomeSdkModule(FlutterOneWelcomeSdkModule(flutterPluginBinding.applicationContext))
            .build()
        component.inject(this)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(onMethodCallMapper)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "onegini_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                OneginiEventsSender.setEventSink(events)
            }

            override fun onCancel(arguments: Any?) {
                OneginiEventsSender.setEventSink(null)
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        UserClientApi.setUp(binding.binaryMessenger, null)
        channel.setMethodCallHandler(null)
    }
}
