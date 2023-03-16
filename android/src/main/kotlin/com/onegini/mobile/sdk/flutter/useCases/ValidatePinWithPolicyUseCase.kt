package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ValidatePinWithPolicyUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(pin: String, callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.validatePinWithPolicy(
      pin.toCharArray(),
      object : OneginiPinValidationHandler {
        override fun onSuccess() {
          callback(Result.success(Unit))
        }

        override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
          callback(
            Result.failure(
              SdkError(
                code = oneginiPinValidationError.errorType,
                message = oneginiPinValidationError.message
              ).pigeonError()
            )
          )
        }
      }
    )
  }
}
