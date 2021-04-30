package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import io.flutter.plugin.common.MethodChannel

class GetAuthenticatedUserProfileUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile != null) {
            result.success(Gson().toJson(authenticatedUserProfile))
        } else {
            result.success(null)
        }

    }
}