package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiFingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class FingerprintAuthenticationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiFingerprintAuthenticationRequestHandler {

    override fun startAuthentication(userProfile: UserProfile, oneginiFingerprintCallback: OneginiFingerprintCallback) {
        fingerprintCallback = oneginiFingerprintCallback
        nativeApi.n2fOpenFingerprintScreen { }
    }

    override fun onNextAuthenticationAttempt() {
        nativeApi.n2fReceivedFingerprint { }
    }

    override fun onFingerprintCaptured() {
        nativeApi.n2fShowScanningFingerprint { }
    }

    override fun finishAuthentication() {
        nativeApi.n2fCloseFingerprintScreen {  }
    }

    companion object {
        var fingerprintCallback: OneginiFingerprintCallback? = null
    }
}
