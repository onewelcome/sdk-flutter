package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HandleMobileAuthWithOtpUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
) {
  operator fun invoke(data: String, callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.handleMobileAuthWithOtp(
      data,
      object : OneginiMobileAuthWithOtpHandler {
        override fun onSuccess() {
          callback(Result.success(Unit))
        }

        override fun onError(otpError: OneginiMobileAuthWithOtpError) {
          callback(
            Result.failure(
              SdkError(
                code = otpError.errorType,
                message = otpError.message
              ).pigeonError()
            )
          )
        }
      }
    )
  }
}
