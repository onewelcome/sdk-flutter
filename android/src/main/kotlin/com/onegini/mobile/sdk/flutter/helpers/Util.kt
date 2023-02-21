package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_PROFILE_DOES_NOT_EXIST
import com.onegini.mobile.sdk.flutter.OneginiSDK

class Util {
  fun getUserProfile(oneginiSDK: OneginiSDK, profileId: String): UserProfile {
    when (val userProfile = oneginiSDK.oneginiClient.userClient.userProfiles.find { it.profileId == profileId }) {
      null -> throw SdkError(USER_PROFILE_DOES_NOT_EXIST)
      else -> return userProfile
    }
  }
}
