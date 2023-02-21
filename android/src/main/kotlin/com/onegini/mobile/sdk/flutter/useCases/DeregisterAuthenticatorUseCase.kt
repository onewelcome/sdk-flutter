package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DeregisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val authenticatorId = call.argument<String>("authenticatorId")
            ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)

        val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
            ?: return SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).flutterError(result)

        val authenticator = getAuthenticatorById(authenticatorId, userProfile)
            ?: return SdkError(AUTHENTICATOR_NOT_FOUND).flutterError(result)

        oneginiSDK.oneginiClient.userClient.deregisterAuthenticator(authenticator, object : OneginiAuthenticatorDeregistrationHandler {
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
        val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == authenticatorId) {
                authenticator = registeredAuthenticator
            }
        }
        return authenticator
    }

}
