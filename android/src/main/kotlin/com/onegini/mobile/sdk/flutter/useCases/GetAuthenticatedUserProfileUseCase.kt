package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_AUTHENTICATED_USER
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAuthenticatedUserProfileUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<OWUserProfile> {
    return when (val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile) {
      null -> Result.failure(SdkError(NOT_AUTHENTICATED_USER).pigeonError())
      else -> Result.success(OWUserProfile(authenticatedUserProfile.profileId))
    }
  }
}
