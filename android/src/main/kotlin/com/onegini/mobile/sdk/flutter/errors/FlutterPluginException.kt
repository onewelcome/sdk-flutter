package com.onegini.mobile.sdk.flutter.errors

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors

class FlutterPluginException constructor(var errorType: Int, message: String): Exception(message) {
    constructor(error: OneWelcomeWrapperErrors) : this(error.code, error.message)
}
