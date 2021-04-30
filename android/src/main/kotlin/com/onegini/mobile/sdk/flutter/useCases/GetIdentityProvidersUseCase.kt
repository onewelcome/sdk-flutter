package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import io.flutter.plugin.common.MethodChannel

class GetIdentityProvidersUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val identityProviders = oneginiClient.userClient.identityProviders
        val providers: ArrayList<Map<String, String>> = ArrayList()
        if (identityProviders != null)
            for (identityProvider in identityProviders) {
                val map = mutableMapOf<String, String>()
                map["id"] = identityProvider.id
                map["name"] = identityProvider.name
                providers.add(map)
            }
        result.success(gson.toJson(providers))
    }
}