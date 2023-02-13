package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DeregisterUserUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val userProfileId = call.argument<String>("profileId")
        if (userProfileId == null) {
            SdkError(USER_PROFILE_DOES_NOT_EXIST).flutterError(result)
            return
        }
        var userProfile: UserProfile? = null
        val userProfiles = oneginiClient.userClient.userProfiles
        for (profile in userProfiles) {
            if (profile.profileId == userProfileId) {
                userProfile = profile
                break
            }
        }
        if (userProfile == null) {
            SdkError(USER_PROFILE_DOES_NOT_EXIST).flutterError(result)
            return
        }
        oneginiClient.userClient.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
                SdkError(
                    code = oneginiDeregistrationError.errorType,
                    message = oneginiDeregistrationError.message
                ).flutterError(result)
            }
        }
        )
    }
}
