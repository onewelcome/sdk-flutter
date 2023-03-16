package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DeregisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return callback(Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError()))

    val authenticator = oneginiSDK.oneginiClient.userClient
      .getRegisteredAuthenticators(userProfile).find { it.id == authenticatorId }
      ?: return callback(Result.failure(SdkError(AUTHENTICATOR_NOT_FOUND).pigeonError()))

    oneginiSDK.oneginiClient.userClient.deregisterAuthenticator(authenticator, object : OneginiAuthenticatorDeregistrationHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(oneginiAuthenticatorDeregistrationError: OneginiAuthenticatorDeregistrationError) {
        callback(
          Result.failure(
            SdkError(
              code = oneginiAuthenticatorDeregistrationError.errorType,
              message = oneginiAuthenticatorDeregistrationError.message
            ).pigeonError()
          )
        )
      }
    }
    )
  }
}
