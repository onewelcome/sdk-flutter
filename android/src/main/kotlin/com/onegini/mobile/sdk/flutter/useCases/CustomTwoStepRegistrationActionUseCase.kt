package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import io.flutter.plugin.common.MethodCall

class CustomTwoStepRegistrationActionUseCase(private var oneginiCustomRegistrationCallback: OneginiCustomRegistrationCallback?) {
    fun returnSuccess(call: MethodCall) {
        val data = call.argument<String>("data")
        oneginiCustomRegistrationCallback?.returnSuccess(data)
    }

    fun returnError(call: MethodCall) {
        val error = call.argument<String>("error")
        oneginiCustomRegistrationCallback?.returnError(Exception(error))
    }
}