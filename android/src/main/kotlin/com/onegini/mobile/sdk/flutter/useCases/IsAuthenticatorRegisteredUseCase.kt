package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class IsAuthenticatorRegisteredUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
        val userProfile = oneginiClient.userClient.authenticatedUserProfile
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
            return
        }
        val authenticator = getAuthenticatorById(authenticatorId, userProfile)
        if (authenticator == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.code, OneginiWrapperErrors.AUTHENTICATOR_NOT_FOUND.message, null)
            return
        }
        result.success(authenticator.isRegistered)
    }

    private fun getAuthenticatorById(authenticatorId: String?, userProfile: UserProfile): OneginiAuthenticator? {
        if (authenticatorId == null) return null
        var foundAuthenticator: OneginiAuthenticator? = null
        val oneginiAuthenticators = oneginiClient.userClient.getAllAuthenticators(userProfile)
        for (oneginiAuthenticator in oneginiAuthenticators) {
            if (oneginiAuthenticator.id == authenticatorId) {
                foundAuthenticator = oneginiAuthenticator
                break
            }
        }
        return foundAuthenticator
    }
}