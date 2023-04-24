package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SetPreferredAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(authenticatorId: String): Result<Unit> {

    val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return Result.failure(SdkError(NOT_AUTHENTICATED_USER).pigeonError())

    val authenticator = oneginiSDK.oneginiClient.userClient
      .getRegisteredAuthenticators(userProfile).find { it.id == authenticatorId }
      ?: return Result.failure(SdkError(NOT_FOUND_AUTHENTICATOR).pigeonError())

    oneginiSDK.oneginiClient.userClient.setPreferredAuthenticator(authenticator)
    return Result.success(Unit)
  }
}
