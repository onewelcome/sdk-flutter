package com.onegini.mobile.sdk.flutter.errors

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.helpers.SdkError

class FlutterPluginException constructor(var errorType: Int, message: String): SdkError(errorType, message) {
    constructor(error: OneWelcomeWrapperErrors) : this(error.code, error.message)
}
