package com.onegini.mobile.sdk.flutter

import android.content.Context
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
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
    // / The MethodChannel that will the communication between Flutter and native Android
    // /
    // / This local reference serves to register the plugin with the Flutter Engine and unregister it
    // / when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "onegini_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                OneginiEventsSender.setEventSink(events)
            }

            override fun onCancel(arguments: Any?) {
                OneginiEventsSender.setEventSink(null)
            }
        })
        context = flutterPluginBinding.applicationContext
    }

    fun setContext(context: Context) {
        this.context = context
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        OnMethodCallMapper(context).onMethodCall(call, result)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
