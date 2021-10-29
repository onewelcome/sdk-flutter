package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodChannel

object AuthenticationObject {

    fun setPreferredAuthenticator(authenticatorId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { oneginiClient.userClient.getRegisteredAuthenticators(it) }

        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == authenticatorId) {
                authenticator = registeredAuthenticator
            }
        }
        if (authenticator == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
            return
        }
        try {
            oneginiClient.userClient.setPreferredAuthenticator(authenticator)
            result.success(true)
        } catch (e: Exception) {
            result.error(OneginiWrapperErrors.PREFERRED_AUTHENTICATOR_ERROR.code, OneginiWrapperErrors.PREFERRED_AUTHENTICATOR_ERROR.message, null)
        }
    }

    fun registerAuthenticator(authenticatorId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
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
            result.error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
            return
        }
        oneginiClient.userClient.registerAuthenticator(
            authenticator,
            object : OneginiAuthenticatorRegistrationHandler {
                override fun onSuccess(customInfo: CustomInfo?) {
                    result.success(customInfo?.data)
                }

                override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                    result.error(oneginiAuthenticatorRegistrationError.errorType.toString(), oneginiAuthenticatorRegistrationError.message, null)
                }
            }
        )
    }

    fun deregisterAuthenticator(authenticatorId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { oneginiClient.userClient.getRegisteredAuthenticators(it) }

        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == authenticatorId) {
                authenticator = registeredAuthenticator
            }
        }
        if (authenticator == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
            return
        }
        oneginiClient.userClient.deregisterAuthenticator(
            authenticator,
            object : OneginiAuthenticatorDeregistrationHandler {
                override fun onSuccess() {
                    result.success(true)
                }

                override fun onError(oneginiAuthenticatorDeregistrationError: OneginiAuthenticatorDeregistrationError) {
                    result.error(oneginiAuthenticatorDeregistrationError.errorType.toString(), oneginiAuthenticatorDeregistrationError.message ?: "", null)
                }
            }
        )
    }

    fun authenticateUser(registeredAuthenticatorsId: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
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
