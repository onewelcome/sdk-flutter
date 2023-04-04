package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.module.FlutterOneWelcomeSdkModule
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceMethodApi
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, PigeonInterface() {
  /// The api that will handle calls from Native -> Flutter
  lateinit var nativeApi: NativeCallFlutterApi

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Pigeon setup
    // We extend PigeonInterface which has all the implementations for when Flutters calls a native method.
    UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)
    ResourceMethodApi.setUp(flutterPluginBinding.binaryMessenger, this)
    nativeApi = NativeCallFlutterApi(flutterPluginBinding.binaryMessenger)

    val component = DaggerFlutterOneWelcomeSdkComponent.builder()
      .flutterOneWelcomeSdkModule(FlutterOneWelcomeSdkModule(flutterPluginBinding.applicationContext, nativeApi))
      .build()
    component.inject(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    UserClientApi.setUp(binding.binaryMessenger, null)
  }
}
