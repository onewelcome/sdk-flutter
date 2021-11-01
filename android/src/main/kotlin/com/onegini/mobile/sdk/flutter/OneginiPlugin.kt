package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin {
    // / The MethodChannel that will the communication between Flutter and native Android
    // /
    // / This local reference serves to register the plugin with the Flutter Engine and unregister it
    // / when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val oneginiSDK = OneginiSDK()
        val oneginiEventsSender = OneginiEventsSender()
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(OnMethodCallMapper(flutterPluginBinding.applicationContext, OneginiMethodsWrapper(), oneginiSDK, oneginiEventsSender))
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "onegini_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                oneginiEventsSender.setEventSink(events)
            }

            override fun onCancel(arguments: Any?) {
                oneginiEventsSender.setEventSink(null)
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
