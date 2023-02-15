package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.pigeonPlugin.PigeonUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
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
        UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)

        val oneginiSDK = OneginiSDK()
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

    override fun fetchUserProfiles(callback: (Result<List<PigeonUserProfile>>) -> Unit) {
        val a = Result.success(listOf(PigeonUserProfile("ghalo", true)))
//        val b = Result.failure<SdkError>(SdkError(OneWelcomeWrapperErrors.GENERIC_ERROR))
        callback(a)
//        callback.onSuccess { listOf(UserProfile("ghalo", true)) }
//        callback?.onFailure { throw Exc }
//        { listOf(UserProfile("ghalo", true)) }
//        callback?.onFailure { SdkError(OneWelcomeWrapperErrors.GENERIC_ERROR) }
    }

}
