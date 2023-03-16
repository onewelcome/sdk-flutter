package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetUserProfilesUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<List<OWUserProfile>> {
    return oneginiSDK.oneginiClient.userClient.userProfiles
      .map { OWUserProfile(it.profileId) }
      .let { Result.success(it) }
  }
}
