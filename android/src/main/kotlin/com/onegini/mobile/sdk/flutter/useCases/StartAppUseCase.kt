package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.models.CustomIdentityProviderConfig
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class StartAppUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val customIdentityProviderConfigs = ArrayList<CustomIdentityProviderConfig>()
        call.argument<ArrayList<String>>("customIdentityProviderConfigs")?.forEach {
            customIdentityProviderConfigs.add(Gson().fromJson(it, CustomIdentityProviderConfig::class.java))
        }

        val connectionTimeout = call.argument<Int>("connectionTimeout")
        val readTimeout = call.argument<Int>("readTimeout")
        val securityControllerClassName = call.argument<String>("securityControllerClassName")
        val configModelClassName = call.argument<String>("configModelClassName")
        val config = Config(configModelClassName, securityControllerClassName, connectionTimeout, readTimeout, customIdentityProviderConfigs)

        oneginiSDK.buildSDK(config, result)
        start(oneginiSDK.oneginiClient, result)
    }

    private fun start(oneginiClient: OneginiClient?, result: MethodChannel.Result) {
        if (oneginiClient == null) {
            SdkError(ONEWELCOME_SDK_NOT_INITIALIZED).flutterError(result)
        } else {
            oneginiSDK.oneginiClient.start(object : OneginiInitializationHandler {
                override fun onSuccess(removedUserProfiles: Set<UserProfile>) {
                    val removedUserProfileArray = getRemovedUserProfileArray(removedUserProfiles)
                    result.success(Gson().toJson(removedUserProfileArray))
                }

                override fun onError(error: OneginiInitializationError) {
                    SdkError(
                        code = error.errorType,
                        message = error.message
                    ).flutterError(result)
                }
            })    
        }
    }

    private fun getRemovedUserProfileArray(removedUserProfiles: Set<UserProfile>): ArrayList<Map<String, Any>> {
        val removedUserProfileArray: ArrayList<Map<String, Any>> = ArrayList()
        for (userProfile in removedUserProfiles) {
            val map = mutableMapOf<String, Any>()
            map["isDefault"] = userProfile.isDefault
            map["profileId"] = userProfile.profileId
            removedUserProfileArray.add(map)
        }
        return removedUserProfileArray
    }
}
