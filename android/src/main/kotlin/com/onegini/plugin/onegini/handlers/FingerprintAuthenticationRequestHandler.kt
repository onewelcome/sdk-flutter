package com.onegini.plugin.onegini.handlers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.request.OneginiFingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.constants.Constants
import com.onegini.plugin.onegini.helpers.OneginiEventsSender


class FingerprintAuthenticationRequestHandler(val context: Context) : OneginiFingerprintAuthenticationRequestHandler {
    
    override fun startAuthentication(userProfile: UserProfile, oneginiFingerprintCallback: OneginiFingerprintCallback) {
        fingerprintCallback = oneginiFingerprintCallback
        OneginiEventsSender.events?.success(Constants.EVENT_OPEN_FINGERPRINT_AUTH)

    }

    override fun onNextAuthenticationAttempt() {
       // startFingerprintActivity(MSG_EXTRA_RECEIVED_FINGERPRINT)
        OneginiEventsSender.events?.success(Constants.EVENT_RECEIVED_FINGERPRINT_AUTH)

    }

    override fun onFingerprintCaptured() {
        OneginiEventsSender.events?.success(Constants.EVENT_SHOW_SCANNING_FINGERPRINT_AUTH)
        // startFingerprintActivity(MSG_EXTRA_SHOW_SCANNING)
    }

    override fun finishAuthentication() {
        OneginiEventsSender.events?.success(Constants.EVENT_CLOSE_FINGERPRINT_AUTH)
        // startFingerprintActivity(MSG_EXTRA_CLOSE)
    }
    
    companion object {
        var fingerprintCallback: OneginiFingerprintCallback? = null
    }

}