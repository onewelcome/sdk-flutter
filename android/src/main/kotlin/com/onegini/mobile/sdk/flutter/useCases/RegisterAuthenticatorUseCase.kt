package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RegisterAuthenticatorUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            SdkError(AUTHENTICATED_USER_PROFILE_IS_NULL).flutterError(result)
            return
        }
        val authenticator = getAuthenticatorById(authenticatorId, authenticatedUserProfile)
        if (authenticator == null) {
            SdkError(AUTHENTICATOR_IS_NULL).flutterError(result)
            return
        }
        oneginiClient.userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                result.success(Gson().toJson(customInfo))
            }

            override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                SdkError(
                    code = oneginiAuthenticatorRegistrationError.errorType,
                    message = oneginiAuthenticatorRegistrationError.message
                ).flutterError(result)
            }
        }
        )
    }

    private fun getAuthenticatorById(authenticatorId: String?, authenticatedUserProfile: UserProfile): OneginiAuthenticator? {
        var authenticator: OneginiAuthenticator? = null
        val notRegisteredAuthenticators = oneginiClient.userClient.getNotRegisteredAuthenticators(authenticatedUserProfile)
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.id == authenticatorId) {
                    authenticator = auth
                }
            }
        }
        return authenticator
    }

}