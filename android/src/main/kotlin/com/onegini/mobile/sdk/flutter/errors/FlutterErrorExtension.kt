package com.onegini.mobile.sdk.flutter.errors

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.wrapperError(error: OneWelcomeWrapperErrors) {
  this.error(error.code.toString(), error.message, null)
}
