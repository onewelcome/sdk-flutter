package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticateUserImplicitlyUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String, scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    // TODO replace this logic with result
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return callback(Result.failure(error.pigeonError()))
    }

    oneginiSDK.oneginiClient.userClient.authenticateUserImplicitly(
      userProfile,
      scopes?.toTypedArray(),
      object : OneginiImplicitAuthenticationHandler {
        override fun onSuccess(profile: UserProfile) {
          callback(Result.success(Unit))
        }

        override fun onError(error: OneginiImplicitTokenRequestError) {
          callback(
            Result.failure(
              SdkError(
                code = error.errorType,
                message = error.message
              ).pigeonError()
            )
          )
        }
      }
    )
  }
}
