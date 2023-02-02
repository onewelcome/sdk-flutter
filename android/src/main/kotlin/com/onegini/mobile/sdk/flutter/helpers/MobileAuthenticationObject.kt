package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import io.flutter.plugin.common.MethodChannel

object MobileAuthenticationObject {

    fun mobileAuthWithOtp(data: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (data == null) {
            SdkError(QR_CODE_HAS_NO_DATA).flutterError(result)
            return
        }
        val userClient = oneginiClient.userClient
        val authenticatedUserProfile = oneginiClient.userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            SdkError(AUTHENTICATED_USER_PROFILE_IS_NULL).flutterError(result)
            return
        }
        if (userClient.isUserEnrolledForMobileAuth(authenticatedUserProfile)) {
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

                    override fun onError(otpError: OneginiMobileAuthWithOtpError) {
                        SdkError(
                            code = otpError.errorType,
                            message = otpError.message
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

            override fun onError(enrollError: OneginiMobileAuthEnrollmentError) {
                SdkError(
                    code = enrollError.errorType,
                    message = enrollError.message
                ).flutterError(result)
            }
        })
    }
}
