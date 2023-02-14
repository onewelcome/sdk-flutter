package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class DeregisterAuthenticatorUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
        val userProfile = oneginiClient.userClient.userProfiles.firstOrNull()
        if (userProfile == null) {
            SdkError(USER_PROFILE_DOES_NOT_EXIST).flutterError(result)
            return
        }
        val authenticator = getAuthenticatorById(authenticatorId, userProfile)
        if (authenticator == null) {
            SdkError(AUTHENTICATOR_IS_NULL).flutterError(result)
            return
        }
        oneginiClient.userClient.deregisterAuthenticator(authenticator, object : OneginiAuthenticatorDeregistrationHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiAuthenticatorDeregistrationError: OneginiAuthenticatorDeregistrationError) {
                SdkError(
                    code = oneginiAuthenticatorDeregistrationError.errorType,
                    message = oneginiAuthenticatorDeregistrationError.message
                ).flutterError(result)
            }
        }
        )
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
