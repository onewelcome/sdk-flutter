package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithOtpRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MobileAuthOtpRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiMobileAuthWithOtpRequestHandler {
    override fun startAuthentication(
            oneginiMobileAuthenticationRequest: OneginiMobileAuthenticationRequest,
            oneginiAcceptDenyCallback: OneginiAcceptDenyCallback
    ) {
        callback = oneginiAcceptDenyCallback
        nativeApi.n2fOpenAuthOtp(oneginiMobileAuthenticationRequest.message) {}
    }

    override fun finishAuthentication() {
        nativeApi.n2fCloseAuthOtp {}
    }

    companion object {
        var callback: OneginiAcceptDenyCallback? = null

        fun acceptAuthenticationRequest(): Result<Unit> {
            return when (val authenticationRequestCallback = callback) {
                null -> Result.failure(SdkError(OneWelcomeWrapperErrors.OTP_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
                else -> {
                    authenticationRequestCallback.acceptAuthenticationRequest()
                    callback = null
                    Result.success(Unit)
                }
            }
        }

        fun denyAuthenticationRequest(): Result<Unit> {
            return when (val authenticationRequestCallback = callback) {
                null -> Result.failure(SdkError(OneWelcomeWrapperErrors.OTP_AUTHENTICATION_NOT_IN_PROGRESS).pigeonError())
                else -> {
                    authenticationRequestCallback.denyAuthenticationRequest()
                    callback = null
                    Result.success(Unit)
                }
            }
        }
    }
}
