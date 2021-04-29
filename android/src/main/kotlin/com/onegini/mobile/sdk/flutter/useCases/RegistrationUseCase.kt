package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class RegistrationUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val identityProviderId = call.argument<String>("identityProviderId")
        val scopes = call.argument<ArrayList<String>>("scopes") ?: ArrayList()
        val identityProvider = getIdentityProviderById(identityProviderId)
        if (identityProviderId != null && identityProvider == null) {
            result.error(OneginiWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND.code, OneginiWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND.message, null)
            return
        }
        register(identityProvider, scopes.toArray(arrayOfNulls<String>(scopes.size)), result)
    }

    private fun getIdentityProviderById(identityProviderId: String?): OneginiIdentityProvider? {
        if (identityProviderId == null) return null
        var foundIdentityProvider: OneginiIdentityProvider? = null
        val identityProviders = oneginiClient.userClient.identityProviders
        for (identityProvider in identityProviders) {
            if (identityProvider.id == identityProviderId) {
                foundIdentityProvider = identityProvider
                break
            }
        }
        return foundIdentityProvider
    }

    private fun register(identityProvider: OneginiIdentityProvider?, scopes: Array<String>, result: MethodChannel.Result) {
        oneginiClient.userClient.registerUser(identityProvider, scopes, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                val returnedResult = Gson().toJson(mapOf("userProfile" to userProfile, "customInfo" to customInfo))
                result.success(returnedResult)
            }

            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                result.error(oneginiRegistrationError.errorType.toString(), oneginiRegistrationError.message, null)
            }
        })
    }
}


