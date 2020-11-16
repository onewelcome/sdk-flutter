package com.example.onegini_test

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar


class OneginiSdkPlugin() : FlutterPlugin {
    var channel: MethodChannel? = null

    /** Plugin registration.  */
    fun registerWith(registrar: Registrar) {
        val plugin = OneginiSdkPlugin()
        plugin.setupMethodChannel(registrar.messenger(), registrar.context())
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        setupMethodChannel(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        tearDownChannel()
    }

    private fun setupMethodChannel(messenger: BinaryMessenger, context: Context) {
        channel = MethodChannel(messenger, "com.onegini/sdk")
        val handler = MethodCallHandlerImpl(context)
        channel!!.setMethodCallHandler(handler)
    }

    private fun tearDownChannel() {
        channel!!.setMethodCallHandler(null)
        channel = null
    }
}