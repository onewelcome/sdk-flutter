package com.onegini.mobile.sdk.flutter.useCases

import android.content.Context
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepIdentityProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class StartAppUseCase(private val context: Context, private val oneginiSDK: OneginiSDK, private val oneginiEventsSender: OneginiEventsSender) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val twoStepCustomIdentityProviderIds = call.argument<ArrayList<String>>("twoStepCustomIdentityProviderIds")
        val connectionTimeout = call.argument<Int>("connectionTimeout")
        val readTimeout = call.argument<Int>("readTimeout")
        val securityControllerClassName = call.argument<String>("securityControllerClassName")
        val configModelClassName = call.argument<String>("configModelClassName")
        val config = Config(configModelClassName, securityControllerClassName)
        val oneginiCustomIdentityProviderList = mutableListOf<OneginiCustomIdentityProvider>()
        twoStepCustomIdentityProviderIds?.forEach { oneginiCustomIdentityProviderList.add(CustomTwoStepIdentityProvider(it)) }
        oneginiSDK.buildSDK(context, connectionTimeout?.toLong(), readTimeout?.toLong(), oneginiCustomIdentityProviderList, config)
        start(oneginiSDK.getOneginiClient(), result)
    }

    private fun start(oneginiClient: OneginiClient, result: MethodChannel.Result) {
        oneginiClient.start(object : OneginiInitializationHandler {
            override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                val removedUserProfileArray = getRemovedUserProfileArray(removedUserProfiles)
                result.success(Gson().toJson(removedUserProfileArray))
            }

            override fun onError(error: OneginiInitializationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }

    private fun getRemovedUserProfileArray(removedUserProfiles: Set<UserProfile?>?): ArrayList<Map<String, Any>> {
        val removedUserProfileArray: ArrayList<Map<String, Any>> = ArrayList()
        if (removedUserProfiles != null) {
            for (userProfile in removedUserProfiles) {
                if (userProfile != null && userProfile.profileId != null) {
                    val map = mutableMapOf<String, Any>()
                    map["isDefault"] = userProfile.isDefault
                    map["profileId"] = userProfile.profileId
                    removedUserProfileArray.add(map)
                }
            }
        }
        return removedUserProfileArray
    }
}