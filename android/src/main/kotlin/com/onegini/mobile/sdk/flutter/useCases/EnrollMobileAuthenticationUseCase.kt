package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class EnrollMobileAuthenticationUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
) {
  operator fun invoke(callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return callback(Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError()))

    oneginiSDK.oneginiClient.userClient.enrollUserForMobileAuth(object : OneginiMobileAuthEnrollmentHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(enrollError: OneginiMobileAuthEnrollmentError) {
        callback(Result.failure(SdkError(
          code = enrollError.errorType,
          message = enrollError.message
        ).pigeonError()))
      }
    })
  }
}
