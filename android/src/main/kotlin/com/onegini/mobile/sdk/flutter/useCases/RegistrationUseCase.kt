package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.oneginiError
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RegistrationUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val identityProviderId = call.argument<String>("identityProviderId")
        val scopes = call.argument<ArrayList<String>>("scopes") ?: ArrayList()
        val identityProvider = getIdentityProviderById(identityProviderId)
        if (identityProviderId != null && identityProvider == null) {
            result.wrapperError(IDENTITY_PROVIDER_NOT_FOUND)
            return
        }
        register(identityProvider, scopes.toArray(arrayOfNulls<String>(scopes.size)), result)
    }

    private fun getIdentityProviderById(identityProviderId: String?): OneginiIdentityProvider? {
        if (identityProviderId == null) return null
        var foundIdentityProvider: OneginiIdentityProvider? = null
        val identityProviders = oneginiSDK.oneginiClient.userClient.identityProviders
        for (identityProvider in identityProviders) {
            if (identityProvider.id == identityProviderId) {
                foundIdentityProvider = identityProvider
                break
            }
        }
        return foundIdentityProvider
    }

    private fun register(identityProvider: OneginiIdentityProvider?, scopes: Array<String>, result: MethodChannel.Result) {
        oneginiSDK.oneginiClient.userClient.registerUser(identityProvider, scopes, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                val userProfileJson = mapOf("profileId" to userProfile.profileId, "isDefault" to userProfile.isDefault)
                val customInfoJson = mapOf("data" to customInfo?.data, "status" to customInfo?.status)
                val returnedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
                result.success(returnedResult)
            }

            override fun onError(error: OneginiRegistrationError) {
                result.oneginiError(error)
            }
        })
    }
}
