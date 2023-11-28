package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import javax.inject.Inject

class GetBiometricAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val getUserProfileUseCase: GetUserProfileUseCase) {
    operator fun invoke(profileId: String): Result<OWAuthenticator> {
        val userProfile = try {
            getUserProfileUseCase(profileId)
        } catch (error: SdkError) {
            return Result.failure(error.pigeonError())
        }
        val authenticators = oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
        val authenticator = authenticators.find { it.type ==  OneginiAuthenticator.BIOMETRIC }
            ?: return Result.failure(SdkError(BIOMETRIC_AUTHENTICATION_NOT_AVAILABLE).pigeonError())

        return Result.success(OWAuthenticator(authenticator.id, authenticator.name, authenticator.isRegistered, authenticator.isPreferred, OWAuthenticatorType.BIOMETRIC))

    }
}
