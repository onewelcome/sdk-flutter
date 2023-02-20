package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.PigeonUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.FlutterException
import io.flutter.plugin.common.MethodChannel


/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, UserClientApi {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // Pigeon setup
        UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)
        val nativeApi = NativeCallFlutterApi(flutterPluginBinding.binaryMessenger)

        val oneginiSDK = OneginiSDK(nativeApi)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(OnMethodCallMapper(flutterPluginBinding.applicationContext, OneginiMethodsWrapper(), oneginiSDK))
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

    // Example function on how it could be initiated on Flutter send to Native
    // Fixme limitation on failure platform exception structure; see
    // https://github.com/flutter/flutter/issues/120861
    override fun fetchUserProfiles(callback: (Result<List<PigeonUserProfile>>) -> Unit) {
        val a = Result.success(listOf(PigeonUserProfile("ghalo", true)))
//        val a = Result.failure<List<PigeonUserProfile>>(Exception("meee", Throwable("boop")))
        callback(a)
    }
}
