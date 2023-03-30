package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ONEWELCOME_SDK_NOT_INITIALIZED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomIdentityProvider
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class StartAppUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(securityControllerClassName: String?,
                        configModelClassName: String?,
                        customIdentityProviderConfigs: List<OWCustomIdentityProvider>?,
                        connectionTimeout: Long?,
                        readTimeout: Long?,
                        callback: (Result<Unit>) -> Unit) {
        try {
            oneginiSDK.buildSDK(securityControllerClassName, configModelClassName, customIdentityProviderConfigs, connectionTimeout, readTimeout)
            start(oneginiSDK.oneginiClient, callback)
        } catch (error: SdkError) {
            callback(Result.failure(error.pigeonError()))
        }
    }

    private fun start(oneginiClient: OneginiClient?, callback: (Result<Unit>) -> Unit) {
        if (oneginiClient == null) {
            callback(Result.failure(SdkError(ONEWELCOME_SDK_NOT_INITIALIZED).pigeonError()))
        } else {
            oneginiSDK.oneginiClient.start(object : OneginiInitializationHandler {
                override fun onSuccess(removedUserProfiles: Set<UserProfile>) {
                    callback(Result.success(Unit))
                }

                override fun onError(error: OneginiInitializationError) {
                    callback(
                        Result.failure(
                            SdkError(
                                code = error.errorType,
                                message = error.message
                            ).pigeonError()
                        )
                    )
                }
            })    
        }
    }
}
