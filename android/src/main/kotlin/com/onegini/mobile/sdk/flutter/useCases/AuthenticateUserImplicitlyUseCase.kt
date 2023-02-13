package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_PROFILE_DOES_NOT_EXIST
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AuthenticateUserImplicitlyUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val profileId = call.argument<String>("profileId")
        val scopes = call.argument<ArrayList<String>>("scopes")

        val userProfile = oneginiClient.userClient.userProfiles.find { it.profileId == profileId }

        if (userProfile == null) {
            SdkError(USER_PROFILE_DOES_NOT_EXIST).flutterError(result)
            return
        }
        oneginiClient.userClient.authenticateUserImplicitly(userProfile, scopes?.toArray(arrayOfNulls<String>(scopes.size)), object : OneginiImplicitAuthenticationHandler {
            override fun onSuccess(profile: UserProfile) {
                result.success(userProfile.profileId)
            }

            override fun onError(error: OneginiImplicitTokenRequestError) {
                SdkError(
                    code = error.errorType,
                    message = error.message
                ).flutterError(result)
            }
        }
        )
    }
}
