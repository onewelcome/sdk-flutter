package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_PROFILE_DOES_NOT_EXIST
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import javax.inject.Inject

class GetBiometricAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val getUserProfileUseCase: GetUserProfileUseCase) {
    operator fun invoke(profileId: String, callback: (Result<OWAuthenticator>) -> Unit) {
        val userProfile = try {
            getUserProfileUseCase(profileId)
        } catch (error: SdkError) {
            return callback(Result.failure(error.pigeonError()))
        }
        val authenticators = oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
        val authenticator = authenticators.find { it.type ==  OneginiAuthenticator.FINGERPRINT }
            ?: return callback(Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE).pigeonError()))

        return callback(Result.success(OWAuthenticator(authenticator.id, authenticator.name, authenticator.isRegistered, authenticator.isPreferred, OWAuthenticatorType.BIOMETRIC)))

    }
}