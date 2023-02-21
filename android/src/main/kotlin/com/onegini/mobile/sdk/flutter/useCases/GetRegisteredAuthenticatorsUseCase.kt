package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.helpers.Util
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetRegisteredAuthenticatorsUseCase @Inject constructor (private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val profileId = call.argument<String>("profileId")
          ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)

        val userProfile = try {
            Util().getUserProfile(oneginiSDK, profileId)
        } catch (error: SdkError) {
            return error.flutterError(result)
        }

        val gson = GsonBuilder().serializeNulls().create()
        val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        for (registeredAuthenticator in registeredAuthenticators) {
            val map = mutableMapOf<String, String>()
            map["id"] = registeredAuthenticator.id
            map["name"] = registeredAuthenticator.name

            /* TODO Extend this callback with additional attributes
             * type, isPreferred, isRegistered
             * https://onewelcome.atlassian.net/browse/FP-46
             */
            authenticators.add(map)
        }
        result.success(gson.toJson(authenticators))
    }
}
