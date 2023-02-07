package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodChannel

class GetAllAuthenticatorsUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            SdkError(AUTHENTICATED_USER_PROFILE_IS_NULL).flutterError(result)
            return
        }
        val allAuthenticators = oneginiClient.userClient.getAllAuthenticators(authenticatedUserProfile)
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (allAuthenticators != null) {
            for (auth in allAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = auth.id
                map["name"] = auth.name
                authenticators.add(map)
            }
        }
        result.success(gson.toJson(authenticators))
    }
}
