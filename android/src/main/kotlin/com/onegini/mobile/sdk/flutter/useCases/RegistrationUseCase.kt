package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile

import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RegistrationUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(identityProviderId: String?, scopes: List<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
        val identityProvider = oneginiSDK.oneginiClient.userClient.identityProviders.find { it.id == identityProviderId }

        if (identityProviderId != null && identityProvider == null) {
            callback(Result.failure(SdkError(IDENTITY_PROVIDER_NOT_FOUND).pigeonError()))
        }

        val registerScopes = scopes?.toTypedArray()

        register(identityProvider, registerScopes, callback)
    }

    private fun register(identityProvider: OneginiIdentityProvider?, scopes: Array<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
        oneginiSDK.oneginiClient.userClient.registerUser(identityProvider, scopes, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                val user = OWUserProfile(userProfile.profileId)

                when (customInfo) {
                    null -> callback(Result.success(OWRegistrationResponse(user)))
                    else -> {
                        val info = OWCustomInfo(customInfo.status.toLong(), customInfo.data)
                        callback(Result.success(OWRegistrationResponse(user, info)))
                    }
                }
            }

            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                callback(Result.failure(
                    SdkError(
                        code = oneginiRegistrationError.errorType,
                        message = oneginiRegistrationError.message
                    ).pigeonError())
                )
            }
        })
    }
}
