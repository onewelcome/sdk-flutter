package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapperImpl(private val registrationUseCase: RegistrationUseCase = RegistrationUseCase()) : IOneginiMethodsWrapper {

     private fun register(identityProvider: OneginiIdentityProvider?, scopes: Array<String>, result: MethodChannel.Result, oneginiClient: OneginiClient, ) {
        registrationUseCase(oneginiClient,identityProvider,scopes) { userProfileId, error ->
            if(userProfileId != null){
                result.success(userProfileId)
            }else{
                result.error(error?.errorType.toString(),error?.message,null)
            }
        }
    }

    override fun registerUser(identityProviderId:String?,scopes:String?,result: MethodChannel.Result,oneginiClient: OneginiClient){
        if(identityProviderId != null){
            val identityProviders = oneginiClient.userClient.identityProviders
            for (identityProvider in identityProviders) {
                if (identityProvider.id == identityProviderId) {
                    register(identityProvider, arrayOf(scopes
                            ?: ""), result, oneginiClient)
                    break
                }
            }
        } else register(null, arrayOf(scopes ?: ""), result, oneginiClient)

    }


}