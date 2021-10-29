package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import io.flutter.plugin.common.MethodChannel

class GetAuthenticatedUserProfileUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile != null) {
            val json = Gson().toJson(mapOf("profileId" to authenticatedUserProfile.profileId, "isDefault" to authenticatedUserProfile.isDefault))
            result.success(json)
        } else {
            result.success(null)
        }
    }
}
