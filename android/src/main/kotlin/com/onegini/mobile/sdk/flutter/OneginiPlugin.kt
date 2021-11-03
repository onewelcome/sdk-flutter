package com.onegini.mobile.sdk.flutter

import android.content.Intent
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, ActivityAware,
        PluginRegistry.NewIntentListener {
    // / The MethodChannel that will the communication between Flutter and native Android
    // /
    // / This local reference serves to register the plugin with the Flutter Engine and unregister it
    // / when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private val oneginiSDK: OneginiSDK = OneginiSDK()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
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

    private fun handleIntent(intent: Intent?) {
        if (intent?.data != null) {
            oneginiSDK.getRegistrationRequestHandler().handleRegistrationCallback(intent.data!!)
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        activityPluginBinding.addOnNewIntentListener(this)
        this.handleIntent(activityPluginBinding.activity.intent)
    }

    override fun onReattachedToActivityForConfigChanges(activityPluginBinding: ActivityPluginBinding) {
        activityPluginBinding.addOnNewIntentListener(this)
        this.handleIntent(activityPluginBinding.activity.intent)
    }

    override fun onNewIntent(intent: Intent?): Boolean {
        this.handleIntent(intent)
        return false
    }

    override fun onDetachedFromActivity() {}

    override fun onDetachedFromActivityForConfigChanges() {}

}
