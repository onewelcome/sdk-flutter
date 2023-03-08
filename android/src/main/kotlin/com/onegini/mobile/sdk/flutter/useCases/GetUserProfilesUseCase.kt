package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetUserProfilesUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<List<OWUserProfile>> {
    val userProfiles = oneginiSDK.oneginiClient.userClient.userProfiles
    val userProfileList = getUserProfileArray(userProfiles)
    return Result.success(userProfileList)
  }

  private fun getUserProfileArray(userProfiles: Set<UserProfile?>?): List<OWUserProfile> {
    val userProfileList = mutableListOf<OWUserProfile>()

    if (userProfiles != null) {
      for (userProfile in userProfiles) {
        if (userProfile != null) {
          userProfileList.add(OWUserProfile(userProfile.profileId))
        }
      }
    }
    return userProfileList
  }
}
