package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ValidatePinWithPolicyUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val nonNullPin = call.argument<String>("pin")?.toCharArray() ?: return SdkError(
            OneWelcomeWrapperErrors.ARGUMENT_NOT_CORRECT.code,
            OneWelcomeWrapperErrors.ARGUMENT_NOT_CORRECT.message + " pin is null"
        ).flutterError(result)

        oneginiSDK.oneginiClient.userClient.validatePinWithPolicy(
            nonNullPin,
            object : OneginiPinValidationHandler {
                override fun onSuccess() {
                    result.success(null)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    SdkError(
                        code = oneginiPinValidationError.errorType,
                        message = oneginiPinValidationError.message
                    ).flutterError(result)
                }
            }
        )
    }
}
