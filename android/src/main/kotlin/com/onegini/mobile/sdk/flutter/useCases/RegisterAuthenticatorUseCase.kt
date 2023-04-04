package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RegisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return callback(Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError()))

    val authenticator = oneginiSDK.oneginiClient.userClient
      .getAllAuthenticators(authenticatedUserProfile).find { it.id == authenticatorId }
      ?: return callback(Result.failure(SdkError(AUTHENTICATOR_NOT_FOUND).pigeonError()))

    oneginiSDK.oneginiClient.userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
      override fun onSuccess(customInfo: CustomInfo?) {
        callback(Result.success(Unit))
      }

      override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
        callback(
          Result.failure(
            SdkError(
              code = oneginiAuthenticatorRegistrationError.errorType,
              message = oneginiAuthenticatorRegistrationError.message
            ).pigeonError()
          )
        )
      }
    }
    )
  }
}
