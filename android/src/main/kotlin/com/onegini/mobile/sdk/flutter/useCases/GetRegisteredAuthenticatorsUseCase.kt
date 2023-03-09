package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetRegisteredAuthenticatorsUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String): Result<List<OWAuthenticator>> {
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return Result.failure(error.pigeonError())
    }

    val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
    val authenticators = mutableListOf<OWAuthenticator>()

    for (registeredAuthenticator in registeredAuthenticators) {
      val authenticator = OWAuthenticator(
        registeredAuthenticator.id,
        registeredAuthenticator.name,
        registeredAuthenticator.isRegistered,
        registeredAuthenticator.isPreferred,
        registeredAuthenticator.type.toLong()
      )

      authenticators.add(authenticator)
    }

    return Result.success(authenticators)
  }
}
