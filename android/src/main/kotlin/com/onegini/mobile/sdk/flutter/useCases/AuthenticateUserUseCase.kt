package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AuthenticateUserUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val registeredAuthenticatorsId = call.argument<String>("registeredAuthenticatorId")
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
            return
        }
        val authenticator = getAuthenticatorById(registeredAuthenticatorsId, userProfile)
        if (registeredAuthenticatorsId != null && authenticator == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.code, OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.message, null)
            return
        }
        authenticate(userProfile, authenticator, result, oneginiClient)
    }

    private fun getAuthenticatorById(registeredAuthenticatorsId: String?, userProfile: UserProfile): OneginiAuthenticator? {
        if (registeredAuthenticatorsId == null) return null
        val registeredAuthenticators = oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == registeredAuthenticatorsId) {
                return registeredAuthenticator
            }
        }
        return null
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
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                //todo check unit tests
                val userProfileJson = mapOf("profileId" to userProfile.profileId,"isDefault" to userProfile.isDefault)
                val customInfoJson = mapOf("data" to customInfo?.data,"status" to customInfo?.status)
                val returnedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
                result.success(returnedResult)
            }

            override fun onError(error: OneginiAuthenticationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        }
    }
}