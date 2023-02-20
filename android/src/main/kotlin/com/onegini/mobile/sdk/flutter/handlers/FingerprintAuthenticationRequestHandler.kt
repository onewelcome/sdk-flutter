package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiFingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class FingerprintAuthenticationRequestHandler @Inject constructor(): OneginiFingerprintAuthenticationRequestHandler {

    override fun startAuthentication(userProfile: UserProfile, oneginiFingerprintCallback: OneginiFingerprintCallback) {
        fingerprintCallback = oneginiFingerprintCallback
        OneginiEventsSender.events?.success(Constants.EVENT_OPEN_FINGERPRINT_AUTH)
    }

    override fun onNextAuthenticationAttempt() {
        OneginiEventsSender.events?.success(Constants.EVENT_RECEIVED_FINGERPRINT_AUTH)
    }

    override fun onFingerprintCaptured() {
        OneginiEventsSender.events?.success(Constants.EVENT_SHOW_SCANNING_FINGERPRINT_AUTH)
    }

    override fun finishAuthentication() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_FINGERPRINT_AUTH)
    }

    companion object {
        var fingerprintCallback: OneginiFingerprintCallback? = null
    }
}
