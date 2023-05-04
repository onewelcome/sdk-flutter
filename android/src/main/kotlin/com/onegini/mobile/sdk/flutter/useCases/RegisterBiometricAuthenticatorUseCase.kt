package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_AUTHENTICATED_USER
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject

class RegisterBiometricAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(callback: (Result<Unit>) -> Unit) {
        val authenticatedUserProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
            ?: return callback(Result.failure(SdkError(NOT_AUTHENTICATED_USER).pigeonError()))

        val biometricAuthenticator = oneginiSDK.oneginiClient.userClient
            .getAllAuthenticators(authenticatedUserProfile).find { it.type ==  OneginiAuthenticator.FINGERPRINT }
            ?: return callback(Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE).pigeonError()))

        oneginiSDK.oneginiClient.userClient.registerAuthenticator(biometricAuthenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                callback(Result.success(Unit))
            }

            override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                callback(
                    Result.failure(
                        SdkError(
                            code = oneginiAuthenticatorRegistrationError.errorType,
                            message = oneginiAuthenticatorRegistrationError.message
                        ).pigeonError()
                    )
                )
            }
        })
    }
}
