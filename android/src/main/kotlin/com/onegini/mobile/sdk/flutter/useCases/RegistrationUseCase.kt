package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class RegistrationUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall,result: MethodChannel.Result) {
        val identityProviderId = call.argument<String>("identityProviderId")
        val scopes = call.argument<String>("scopes")
        if(identityProviderId != null){
            val identityProviders = oneginiClient.userClient.identityProviders
            for (identityProvider in identityProviders) {
                if (identityProvider.id == identityProviderId) {
                    register(identityProvider, arrayOf(scopes
                            ?: ""),result)
                    break
                }
            }
        } else register(null, arrayOf(scopes ?: ""),result)

    }
    private fun  register(identityProvider: OneginiIdentityProvider?, scopes: Array<String>,result: MethodChannel.Result){
        oneginiClient.userClient.registerUser(identityProvider, scopes, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                result.success(userProfile.profileId)
            }

            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                result.error(oneginiRegistrationError.errorType.toString(),oneginiRegistrationError.message,null)
            }
        })
    }
}


