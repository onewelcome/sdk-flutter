package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import android.util.Log
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel

object QrCodeHelper {

    fun mobileAuthWithOtp(context:Context,data: String?, result: MethodChannel.Result) {
        val userClient = OneginiSDK.getOneginiClient(context).userClient
        if (userClient == null) {
            result.error(ErrorHelper().clientIsNull.code, ErrorHelper().clientIsNull.message, null)
            return
        }
        val authenticatedUserProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(ErrorHelper().authenticatedUserProfileIsNull.code, ErrorHelper().authenticatedUserProfileIsNull.message, null)
            return
        }
        if (authenticatedUserProfile.let { userClient.isUserEnrolledForMobileAuth(it) }) {
            handleOTPAuth(context,data, result)
        } else {
            enrollMobileAuthentication(context,data, result)
        }


    }
    private fun handleOTPAuth(context:Context,data: String?, result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context).userClient.handleMobileAuthWithOtp(data
                ?: "", object : OneginiMobileAuthWithOtpHandler {
            override fun onSuccess() {
                result.success("success auth with otp")
            }

            override fun onError(p0: OneginiMobileAuthWithOtpError?) {
                Log.e("QR", "${p0?.message} ", p0?.cause)
                result.error(p0?.errorType.toString(), p0?.message, p0?.cause?.message)
            }
        })
    }

    private fun enrollMobileAuthentication(context:Context,data: String?, result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context).userClient.enrollUserForMobileAuth(object : OneginiMobileAuthEnrollmentHandler {
            override fun onSuccess() {
                handleOTPAuth(context,data, result)
            }

            override fun onError(p0: OneginiMobileAuthEnrollmentError?) {
                result.error(p0?.errorType.toString(), p0?.message, p0?.cause?.message.toString())
            }

        })
    }

}