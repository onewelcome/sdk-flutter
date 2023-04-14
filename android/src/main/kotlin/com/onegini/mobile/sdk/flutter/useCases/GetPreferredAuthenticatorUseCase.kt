package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOneginiInt
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import javax.inject.Inject

class GetPreferredAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(callback: (Result<OWAuthenticator>) -> Unit) {
        val authenticator = oneginiSDK.oneginiClient.userClient.preferredAuthenticator
            ?: return callback(Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED).pigeonError()))

        if (authenticator.type == OWAuthenticatorType.PIN.toOneginiInt()) {
            return callback(Result.success(OWAuthenticator(authenticator.id, authenticator.name, authenticator.isRegistered, authenticator.isPreferred, OWAuthenticatorType.PIN)))
        }
        if (authenticator.type == OWAuthenticatorType.BIOMETRIC.toOneginiInt()) {
            return callback(Result.success(OWAuthenticator(authenticator.id, authenticator.name, authenticator.isRegistered, authenticator.isPreferred, OWAuthenticatorType.BIOMETRIC)))
        }
        // This should never happen because we don't support CUSTOM/FIDO authenticators
        return callback(Result.failure(SdkError(GENERIC_ERROR).pigeonError()))
    }
}