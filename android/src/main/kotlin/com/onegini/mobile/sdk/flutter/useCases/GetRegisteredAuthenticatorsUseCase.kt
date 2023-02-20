package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetRegisteredAuthenticatorsUseCase @Inject constructor (private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val userProfile = oneginiSDK.oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            SdkError(USER_PROFILE_DOES_NOT_EXIST).flutterError(result)
            return
        }
        val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        for (registeredAuthenticator in registeredAuthenticators) {
            val map = mutableMapOf<String, String>()
            map["id"] = registeredAuthenticator.id
            map["name"] = registeredAuthenticator.name
            authenticators.add(map)
        }
        result.success(gson.toJson(authenticators))
    }

}
