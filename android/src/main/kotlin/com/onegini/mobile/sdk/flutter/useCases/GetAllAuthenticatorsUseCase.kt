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

    return oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
      .map { OWAuthenticator(it.id, it.name, it.isRegistered, it.isPreferred, it.type.toLong()) }
      .let { Result.success(it) }
  }
}
