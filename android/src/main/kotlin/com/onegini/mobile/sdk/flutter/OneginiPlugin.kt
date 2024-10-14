package com.onegini.mobile.sdk.flutter

import androidx.annotation.NonNull
import android.app.Activity
import android.content.Context
import com.onegini.mobile.sdk.flutter.module.FlutterOneWelcomeSdkModule
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceMethodApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** OneginiPlugin */
class OneginiPlugin : FlutterPlugin, PigeonInterface(), ActivityAware {
  /// The api that will handle calls from Native -> Flutter
  lateinit var nativeApi: NativeCallFlutterApi
  lateinit var activity: Activity
  lateinit var context: Context
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    // Pigeon setup
    // We extend PigeonInterface which has all the implementations for when Flutters calls a native method.
    UserClientApi.setUp(flutterPluginBinding.binaryMessenger, this)
    ResourceMethodApi.setUp(flutterPluginBinding.binaryMessenger, this)
    nativeApi = NativeCallFlutterApi(flutterPluginBinding.binaryMessenger)
    context = flutterPluginBinding.applicationContext
  }
  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    UserClientApi.setUp(binding.binaryMessenger, null)
  }
  override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
    activity = activityPluginBinding.activity

    val component = DaggerFlutterOneWelcomeSdkComponent.builder()
            .flutterOneWelcomeSdkModule(FlutterOneWelcomeSdkModule(context, activity, nativeApi))
            .build()
    component.inject(this)
  }
  override fun onDetachedFromActivityForConfigChanges() {
  }
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }
  override fun onDetachedFromActivity() {
  }
}