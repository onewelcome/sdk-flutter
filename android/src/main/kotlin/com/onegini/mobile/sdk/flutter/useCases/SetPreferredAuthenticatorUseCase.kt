package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SetPreferredAuthenticatorUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.USER_PROFILE_IS_NULL.message, null)
            return
        }
        val authenticator = getAuthenticatorById(authenticatorId, userProfile)
        if (authenticator == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATOR_IS_NULL.message, null)
            return
        }
        oneginiClient.userClient.setPreferredAuthenticator(authenticator)
        result.success(true)

    }

    private fun getAuthenticatorById(authenticatorId: String?, userProfile: UserProfile): OneginiAuthenticator? {
        var authenticator: OneginiAuthenticator? = null
        val registeredAuthenticators = oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == authenticatorId) {
                authenticator = registeredAuthenticator
            }
        }
        return authenticator
    }
}