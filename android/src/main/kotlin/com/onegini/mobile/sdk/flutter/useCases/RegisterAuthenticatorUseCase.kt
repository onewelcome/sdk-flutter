package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.METHOD_ARGUMENT_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.oneginiError
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RegisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
            ?: return result.wrapperError(METHOD_ARGUMENT_NOT_FOUND)

        val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
            ?: return result.wrapperError(NO_USER_PROFILE_IS_AUTHENTICATED)

        val authenticator = getAuthenticatorById(authenticatorId, authenticatedUserProfile)
            ?: return result.wrapperError(AUTHENTICATOR_NOT_FOUND)

        oneginiSDK.oneginiClient.userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                result.success(Gson().toJson(customInfo))
            }

            override fun onError(error: OneginiAuthenticatorRegistrationError) {
                result.oneginiError(error)
            }
        }
        )
    }

    private fun getAuthenticatorById(authenticatorId: String?, authenticatedUserProfile: UserProfile): OneginiAuthenticator? {
        var authenticator: OneginiAuthenticator? = null
        val notRegisteredAuthenticators = oneginiSDK.oneginiClient.userClient.getNotRegisteredAuthenticators(authenticatedUserProfile)
        for (auth in notRegisteredAuthenticators) {
            if (auth.id == authenticatorId) {
                authenticator = auth
            }
        }
        return authenticator
    }
}
