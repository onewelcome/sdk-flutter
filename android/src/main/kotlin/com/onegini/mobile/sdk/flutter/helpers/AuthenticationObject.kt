package com.onegini.mobile.sdk.flutter.helpers

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodChannel

object AuthenticationObject {


    fun getNotRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        val gson = GsonBuilder().serializeNulls().create()
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(OneginiWrapperErrors().authenticatedUserProfileIsNull.code, OneginiWrapperErrors().authenticatedUserProfileIsNull.message, null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { oneginiClient.userClient.getNotRegisteredAuthenticators(it) }
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = auth.id
                map["name"] = auth.name
                authenticators.add(map)
            }
        }
        result.success(gson.toJson(authenticators))
    }


    fun setPreferredAuthenticator(authenticatorId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors().userProfileIsNull.code, OneginiWrapperErrors().userProfileIsNull.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { oneginiClient.userClient.getRegisteredAuthenticators(it) }

        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == authenticatorId) {
                authenticator = registeredAuthenticator
            }
        }
        if (authenticator == null) {
            result.error(OneginiWrapperErrors().authenticatorIsNull.code, OneginiWrapperErrors().authenticatorIsNull.message, null)
            return
        }
        try {
            oneginiClient.userClient.setPreferredAuthenticator(authenticator)
            result.success(true)
        } catch (e: Exception) {
            result.error(OneginiWrapperErrors().preferredAuthenticator.code, OneginiWrapperErrors().preferredAuthenticator.message, null)
        }

    }

    fun registerAuthenticator(authenticatorId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(OneginiWrapperErrors().authenticatedUserProfileIsNull.code, OneginiWrapperErrors().authenticatedUserProfileIsNull.message, null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { oneginiClient.userClient.getNotRegisteredAuthenticators(it) }
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.id == authenticatorId) {
                    authenticator = auth
                }
            }
        }
        if (authenticator == null) {
            result.error(OneginiWrapperErrors().authenticatorIsNull.code, OneginiWrapperErrors().authenticatorIsNull.message, null)
            return
        }
        oneginiClient.userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                result.success(customInfo?.data)
            }

            override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                result.error(oneginiAuthenticatorRegistrationError.errorType.toString(), oneginiAuthenticatorRegistrationError.message, null)
            }
        })
    }


    fun getRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        val gson = GsonBuilder().serializeNulls().create()
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors().userProfileIsNull.code, OneginiWrapperErrors().userProfileIsNull.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { oneginiClient.userClient.getRegisteredAuthenticators(it) }
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (registeredAuthenticators != null)
            for (registeredAuthenticator in registeredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = registeredAuthenticator.id
                map["name"] = registeredAuthenticator.name
                authenticators.add(map)
            }
        result.success(gson.toJson(authenticators))
    }

    fun authenticateUser(registeredAuthenticatorsId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors().userProfileIsNull.code, OneginiWrapperErrors().userProfileIsNull.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { oneginiClient.userClient.getRegisteredAuthenticators(it) }
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == registeredAuthenticatorsId) {
                authenticator = registeredAuthenticator
                break
            }
        }
        authenticate(userProfile, authenticator, result, oneginiClient)
    }

    private fun authenticate(userProfile: UserProfile, authenticator: OneginiAuthenticator?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (authenticator == null) {
            oneginiClient.userClient.authenticateUser(userProfile, getOneginiAuthenticationHandler(result))

        } else {
            oneginiClient.userClient.authenticateUser(userProfile, authenticator, getOneginiAuthenticationHandler(result))
        }
    }

    private fun getOneginiAuthenticationHandler(result: MethodChannel.Result): OneginiAuthenticationHandler {
        return object : OneginiAuthenticationHandler {
            override fun onSuccess(userProfile: UserProfile, p1: CustomInfo?) {
                result.success(userProfile.profileId)
            }

            override fun onError(error: OneginiAuthenticationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        }
    }
}