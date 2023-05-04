package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_AUTHENTICATED_USER
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject

class DeregisterBiometricAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(callback: (Result<Unit>) -> Unit) {
        val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
            ?: return callback(Result.failure(SdkError(NOT_AUTHENTICATED_USER).pigeonError()))
        val authenticators = oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
        val biometricAuthenticator = authenticators.find { it.type == OneginiAuthenticator.FINGERPRINT }
            ?: return callback(Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE).pigeonError()))

        oneginiSDK.oneginiClient.userClient.deregisterAuthenticator(biometricAuthenticator, object : OneginiAuthenticatorDeregistrationHandler {
            override fun onSuccess() {
                callback(Result.success(Unit))
            }

            override fun onError(oneginiAuthenticatorDeregistrationError: OneginiAuthenticatorDeregistrationError) {
                callback(
                    Result.failure(
                        SdkError(
                            code = oneginiAuthenticatorDeregistrationError.errorType,
                            message = oneginiAuthenticatorDeregistrationError.message
                        ).pigeonError()
                    )
                )
            }
        })
    }
}
