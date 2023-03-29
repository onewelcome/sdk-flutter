package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWOneginiError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PinRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiCreatePinRequestHandler {

    companion object {
        var callback: OneginiPinCallback? = null
    }

    override fun startPinCreation(userProfile: UserProfile, oneginiPinCallback: OneginiPinCallback, p2: Int) {
        callback = oneginiPinCallback
        nativeApi.n2fOpenPinRequestScreen { }
    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError) {
        nativeApi.n2fEventPinNotAllowed(OWOneginiError(oneginiPinValidationError.errorType.toLong(), oneginiPinValidationError.message ?: "")) {}
    }

    override fun finishPinCreation() {
        nativeApi.n2fClosePin { }
    }
}
