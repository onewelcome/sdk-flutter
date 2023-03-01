package com.onegini.mobile.sdk.flutter.errors

import com.onegini.mobile.sdk.android.handlers.error.OneginiError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.wrapperError(error: OneWelcomeWrapperErrors) {
    this.errorDefaultDetails(error.code, error.message)
}

fun MethodChannel.Result.wrapperError(error: FlutterPluginException) {
    this.errorDefaultDetails(error.errorType, error.message)
}

fun MethodChannel.Result.oneginiError(error: OneginiError) {
    this.errorDefaultDetails(error.errorType, error.message)
}

fun MethodChannel.Result.errorDefaultDetails(errorCode: Int, errorMessage: String?) {
    this.error(errorCode.toString(), errorMessage, mutableMapOf(
        "code" to errorCode.toString(),
        "message" to errorMessage
    ))
}

fun MethodChannel.Result.errorWithDetails(errorCode: Int, errorMessage: String?, details: Map<String, Any>) {
    val defaultDetails = mutableMapOf(
        "code" to errorCode.toString(),
        "message" to errorMessage
    )
    this.error(errorCode.toString(), errorMessage, defaultDetails + details)
}
