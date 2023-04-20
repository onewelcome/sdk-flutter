package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.GENERIC_ERROR
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_PROFILE_DOES_NOT_EXIST
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOneginiInt
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import javax.inject.Inject

class GetPreferredAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val getUserProfileUseCase: GetUserProfileUseCase) {
    operator fun invoke(profileId: String): Result<OWAuthenticator> {
        val userProfile = try {
            getUserProfileUseCase(profileId)
        } catch (error: SdkError) {
            return Result.failure(error.pigeonError())
        }
        val authenticators = oneginiSDK.oneginiClient.userClient.getAllAuthenticators(userProfile)
        val authenticator = authenticators.find { it.isPreferred }
            ?: return Result.failure(SdkError(GENERIC_ERROR).pigeonError())

        val authenticatorType = when (authenticator.type) {
            OWAuthenticatorType.PIN.toOneginiInt() -> OWAuthenticatorType.PIN
            OWAuthenticatorType.BIOMETRIC.toOneginiInt() -> OWAuthenticatorType.BIOMETRIC
            // This should never happen because we don't support CUSTOM/FIDO authenticators
            else -> null
        } ?: return Result.failure(SdkError(GENERIC_ERROR).pigeonError())

        return  Result.success(OWAuthenticator(authenticator.id, authenticator.name, authenticator.isRegistered, authenticator.isPreferred, authenticatorType))
    }
}
