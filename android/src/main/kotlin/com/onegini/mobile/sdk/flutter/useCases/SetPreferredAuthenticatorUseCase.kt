package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOneginiInt
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SetPreferredAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(authenticatorType: OWAuthenticatorType): Result<Unit> {

    val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError())

    val authenticator = oneginiSDK.oneginiClient.userClient
      .getRegisteredAuthenticators(userProfile).find { it.type == authenticatorType.toOneginiInt() }
      ?: return Result.failure(SdkError(AUTHENTICATOR_NOT_FOUND).pigeonError())

    oneginiSDK.oneginiClient.userClient.setPreferredAuthenticator(authenticator)
    return Result.success(Unit)
  }
}
