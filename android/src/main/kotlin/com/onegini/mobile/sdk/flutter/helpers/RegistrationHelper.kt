package com.onegini.mobile.sdk.flutter.helpers

import android.net.Uri
import androidx.annotation.Nullable
import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import io.flutter.plugin.common.MethodChannel

object RegistrationHelper {

    private fun register(@Nullable identityProvider: OneginiIdentityProvider?, scopes: Array<String>, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.registerUser(
            identityProvider, scopes,
            object : OneginiRegistrationHandler {
                override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                    result.success(userProfile.profileId)
                }

                override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                    result.error(oneginiRegistrationError.errorType.toString(), oneginiRegistrationError.message, null)
                }
            }
        )
    }

    fun handleRegistrationCallback(uri: Uri) {
        RegistrationRequestHandler.handleRegistrationCallback(uri)
    }

    fun cancelRegistration() {
        RegistrationRequestHandler.onRegistrationCanceled()
    }

    fun registerUser(identityProviderId: String?, scopes: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (identityProviderId != null) {
            val identityProviders = oneginiClient.userClient.identityProviders
            for (identityProvider in identityProviders) {
                if (identityProvider.id == identityProviderId) {
                    register(identityProvider, arrayOf(scopes ?: ""), result, oneginiClient)
                    break
                }
            }
        } else register(null, arrayOf(scopes ?: ""), result, oneginiClient)
    }

    fun getIdentityProviders(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        val gson = GsonBuilder().serializeNulls().create()
        val identityProviders = oneginiClient.userClient.identityProviders
        val providers: ArrayList<Map<String, String>> = ArrayList()
        if (identityProviders != null)
            for (identityProvider in identityProviders) {
                val map = mutableMapOf<String, String>()
                map["id"] = identityProvider.id
                map["name"] = identityProvider.name
                providers.add(map)
            }
        result.success(gson.toJson(providers))
    }

    fun deregisterUser(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        val userProfile = oneginiClient.userClient.authenticatedUserProfile
        if (userProfile == null) {
            result.error(OneginiWrapperErrors().userProfileIsNull.code, OneginiWrapperErrors().userProfileIsNull.message, null)
            return
        }
        oneginiClient.userClient.deregisterUser(
            userProfile,
            object : OneginiDeregisterUserProfileHandler {
                override fun onSuccess() {
                    result.success(true)
                }

                override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
                    result.error(oneginiDeregistrationError.errorType.toString(), oneginiDeregistrationError.message, null)
                }
            }
        )
    }
}
