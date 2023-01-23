package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodChannel

class GetRegisteredAuthenticatorsUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            SdkError(USER_PROFILE_IS_NULL_ERROR).flutterError(result)
            return
        }
        val registeredAuthenticators = oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (registeredAuthenticators != null) {
            for (registeredAuthenticator in registeredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = registeredAuthenticator.id
                map["name"] = registeredAuthenticator.name
                authenticators.add(map)
            }
        }
        result.success(gson.toJson(authenticators))
    }

}