package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAllAuthenticatorsUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String): Result<List<OWAuthenticator>> {
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return Result.failure(error.pigeonError())
    }

    val allAuthenticators = oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
    val authenticators = mutableListOf<OWAuthenticator>()

    for (auth in allAuthenticators) {
      val authenticator = OWAuthenticator(
        auth.id,
        auth.name,
        auth.isRegistered,
        auth.isPreferred,
        auth.type.toLong()
      )

      authenticators.add(authenticator)
    }

    return Result.success(authenticators)
  }
}
