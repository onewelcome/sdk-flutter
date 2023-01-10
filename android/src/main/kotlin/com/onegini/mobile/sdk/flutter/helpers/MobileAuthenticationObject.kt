package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import io.flutter.plugin.common.MethodChannel

object MobileAuthenticationObject {

    fun mobileAuthWithOtp(data: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (data == null) {
            SdkError(
                wrapperError = OneWelcomeWrapperErrors.QR_CODE_NOT_HAVE_DATA
            ).flutterError(result)
            return
        }
        val userClient = oneginiClient.userClient
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            SdkError(
                wrapperError = OneWelcomeWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL
            ).flutterError(result)
            return
        }
        if (authenticatedUserProfile.let { userClient.isUserEnrolledForMobileAuth(it) }) {
            handleMobileAuthWithOtp(data, result, oneginiClient)
        } else {
            enrollMobileAuthentication(data, result, oneginiClient)
        }
    }

    private fun handleMobileAuthWithOtp(data: String, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.handleMobileAuthWithOtp(
                data,
                object : OneginiMobileAuthWithOtpHandler {
                    override fun onSuccess() {
                        result.success("success auth with otp")
                    }

                    override fun onError(p0: OneginiMobileAuthWithOtpError) {
//                        TODO Investigate what p0 is?
                        SdkError(
                            code = p0.errorType,
                            message = p0.message
                        ).flutterError(result)
                    }
                }
        )
    }

    private fun enrollMobileAuthentication(data: String, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.enrollUserForMobileAuth(object : OneginiMobileAuthEnrollmentHandler {
            override fun onSuccess() {
                handleMobileAuthWithOtp(data, result, oneginiClient)
            }

            override fun onError(p0: OneginiMobileAuthEnrollmentError) {
                SdkError(
                    code = p0.errorType,
                    message = p0.message
                ).flutterError(result)
            }
        })
    }
}
