package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAuthenticatedUserProfileUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile != null) {
            val json = Gson().toJson(mapOf("profileId" to authenticatedUserProfile.profileId))
            result.success(json)
        } else {
            result.wrapperError(AUTHENTICATED_USER_PROFILE_IS_NULL)
        }
    }
}
