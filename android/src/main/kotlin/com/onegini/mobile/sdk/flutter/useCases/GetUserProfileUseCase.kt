package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetUserProfileUseCase @Inject constructor (private val oneginiSDK: OneginiSDK) {
  operator fun invoke(profileId: String): UserProfile {
    when (val userProfile = oneginiSDK.oneginiClient.userClient.userProfiles.find { it.profileId == profileId }) {
      null -> throw FlutterPluginException(OneWelcomeWrapperErrors.USER_PROFILE_DOES_NOT_EXIST)
      else -> return userProfile
    }
  }
}
