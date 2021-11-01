package com.onegini.mobile.sdk.flutter.handlers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.request.OneginiFingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender

class FingerprintAuthenticationRequestHandler(private val oneginiEventsSender: OneginiEventsSender) : OneginiFingerprintAuthenticationRequestHandler {

    override fun startAuthentication(userProfile: UserProfile, oneginiFingerprintCallback: OneginiFingerprintCallback) {
        fingerprintCallback = oneginiFingerprintCallback
        oneginiEventsSender.events?.success(Constants.EVENT_OPEN_FINGERPRINT_AUTH)
    }

    override fun onNextAuthenticationAttempt() {
        oneginiEventsSender.events?.success(Constants.EVENT_RECEIVED_FINGERPRINT_AUTH)
    }

    override fun onFingerprintCaptured() {
        oneginiEventsSender.events?.success(Constants.EVENT_SHOW_SCANNING_FINGERPRINT_AUTH)
    }

    override fun finishAuthentication() {
        oneginiEventsSender.events?.success(Constants.EVENT_CLOSE_FINGERPRINT_AUTH)
    }

    companion object {
        var fingerprintCallback: OneginiFingerprintCallback? = null
    }
}
