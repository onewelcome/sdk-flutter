package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodChannel

class GetNotRegisteredAuthenticatorsUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
            return
        }
        val notRegisteredAuthenticators = oneginiClient.userClient.getNotRegisteredAuthenticators(authenticatedUserProfile)
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = auth.id
                map["name"] = auth.name
                authenticators.add(map)
            }
        }
        result.success(gson.toJson(authenticators))
    }

}