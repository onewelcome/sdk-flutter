package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SetPreferredAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(authenticatorId: String): Result<Unit> {

    val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED))

    val authenticator = getAuthenticatorById(authenticatorId, userProfile)
      ?: return Result.failure(SdkError(AUTHENTICATOR_NOT_FOUND))

    oneginiSDK.oneginiClient.userClient.setPreferredAuthenticator(authenticator)
    return Result.success(Unit)
  }

  private fun getAuthenticatorById(authenticatorId: String?, userProfile: UserProfile): OneginiAuthenticator? {
    var authenticator: OneginiAuthenticator? = null
    val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
    for (registeredAuthenticator in registeredAuthenticators) {
      if (registeredAuthenticator.id == authenticatorId) {
        authenticator = registeredAuthenticator
      }
    }
    return authenticator
  }
}
