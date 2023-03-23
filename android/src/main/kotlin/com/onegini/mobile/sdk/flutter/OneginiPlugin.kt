package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.module.FlutterOneWelcomeSdkModule
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
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
    lateinit var nativeApi : NativeCallFlutterApi

    @Inject
    lateinit var onMethodCallMapper: OnMethodCallMapper
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // Pigeon setup
        UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)
        ResourceMethodApi.setUp(flutterPluginBinding.binaryMessenger, this)
        nativeApi = NativeCallFlutterApi(flutterPluginBinding.binaryMessenger)

        val component = DaggerFlutterOneWelcomeSdkComponent.builder()
            .flutterOneWelcomeSdkModule(FlutterOneWelcomeSdkModule(flutterPluginBinding.applicationContext, nativeApi))
            .build()
        component.inject(this)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "onegini")
        channel.setMethodCallHandler(onMethodCallMapper)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        UserClientApi.setUp(binding.binaryMessenger, null)
        channel.setMethodCallHandler(null)
    }
}
