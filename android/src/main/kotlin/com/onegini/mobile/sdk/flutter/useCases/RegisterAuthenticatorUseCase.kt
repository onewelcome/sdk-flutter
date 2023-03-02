package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RegisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
            ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)

        val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
            ?: return SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).flutterError(result)

        val authenticator = getAuthenticatorById(authenticatorId, authenticatedUserProfile)
            ?: return SdkError(AUTHENTICATOR_NOT_FOUND).flutterError(result)

        oneginiSDK.oneginiClient.userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
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
        val notRegisteredAuthenticators = oneginiSDK.oneginiClient.userClient.getNotRegisteredAuthenticators(authenticatedUserProfile)
        for (auth in notRegisteredAuthenticators) {
            if (auth.id == authenticatorId) {
                authenticator = auth
            }
        }
        return authenticator
    }
}
