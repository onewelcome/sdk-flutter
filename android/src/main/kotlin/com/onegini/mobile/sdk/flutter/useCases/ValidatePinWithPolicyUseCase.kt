package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ValidatePinWithPolicyUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val pin = call.argument<String>("pin")?.toCharArray()
        oneginiClient.userClient.validatePinWithPolicy(
                pin,
                object : OneginiPinValidationHandler {
                    override fun onSuccess() {
                        result.success(true)
                    }

                    override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                        result.error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message, null)
                    }
                }
        )
    }
}