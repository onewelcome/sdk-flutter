package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DeregisterUserUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String, callback: (Result<Unit>) -> Unit) {

    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return callback(Result.failure(error.pigeonError()))
    }

    oneginiSDK.oneginiClient.userClient.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
        callback(
          Result.failure(
            SdkError(
              code = oneginiDeregistrationError.errorType,
              message = oneginiDeregistrationError.message
            ).pigeonError()
          )
        )
      }
    })
  }
}
