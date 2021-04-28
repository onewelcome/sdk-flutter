package com.onegini.mobile.sdk.flutter.useCases

import android.content.Context
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepIdentityProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class StartAppUseCase {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result, context: Context,oneginiSDK: OneginiSDK) {
        val twoStepCustomIdentityProviderIds = call.argument<ArrayList<String>>("twoStepCustomIdentityProviderIds")
        val connectionTimeout = call.argument<Int>("connectionTimeout")
        val readTimeout = call.argument<Int>("readTimeout")
        val oneginiCustomIdentityProviderList = mutableListOf<OneginiCustomIdentityProvider>()
        twoStepCustomIdentityProviderIds?.forEach { oneginiCustomIdentityProviderList.add(CustomTwoStepIdentityProvider(it)) }
        val oneginiClient: OneginiClient = oneginiSDK.initSDK(context, connectionTimeout?.toLong(), readTimeout?.toLong(), oneginiCustomIdentityProviderList)
        oneginiClient.start(object : OneginiInitializationHandler {
            override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                val removedUserProfileArray: ArrayList<Map<String, Any>> = ArrayList()
                if (removedUserProfiles != null) {
                    for (userProfile in removedUserProfiles) {
                        val map = mutableMapOf<String, Any>()
                        map["isDefault"] = userProfile?.isDefault ?: false
                        map["profileId"] = userProfile?.profileId ?: ""
                        removedUserProfileArray.add(map)
                    }
                }
                result.success(Gson().toJson(removedUserProfileArray))
            }

            override fun onError(error: OneginiInitializationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }
}