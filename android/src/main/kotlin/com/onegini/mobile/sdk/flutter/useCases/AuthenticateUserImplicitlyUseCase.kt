package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AuthenticateUserImplicitlyUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val scope = call.argument<ArrayList<String>>("scope")
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
            return
        }
        oneginiClient.userClient.authenticateUserImplicitly(userProfile, scope?.toArray(arrayOfNulls<String>(scope.size)), object : OneginiImplicitAuthenticationHandler {
            override fun onSuccess(profile: UserProfile) {
                result.success(Gson().toJson(userProfile))
            }

            override fun onError(error: OneginiImplicitTokenRequestError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        }
        )
    }
}