package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithPushEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithPushEnrollmentError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class EnrollUserForMobileAuthWithPushUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(registrationId: String, callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.enrollUserForMobileAuthWithPush(
      registrationId,
      object : OneginiMobileAuthWithPushEnrollmentHandler {
        override fun onSuccess() {
          Result.success(Unit)
        }

        override fun onError(error: OneginiMobileAuthWithPushEnrollmentError) {
          callback(
            Result.failure(SdkError(error.errorType, error.message).pigeonError())
          )
        }
      })
  }
}
