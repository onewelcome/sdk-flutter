package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import io.flutter.plugin.common.MethodChannel

class GetUserProfilesUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val userProfiles = oneginiClient.userClient.userProfiles
        result.success(Gson().toJson(userProfiles))
    }
}