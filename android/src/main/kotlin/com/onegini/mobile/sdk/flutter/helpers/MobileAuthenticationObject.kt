package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodChannel

object MobileAuthenticationObject {

    fun mobileAuthWithOtp(context:Context,data: String?, result: MethodChannel.Result) {
        if(data==null){
            result.error(OneginiWrapperErrors().qrCodeNotHaveData.code, OneginiWrapperErrors().qrCodeNotHaveData.message, null)
            return
        }
        val userClient = OneginiSDK().getOneginiClient(context).userClient
        val authenticatedUserProfile = OneginiSDK().getOneginiClient(context).userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(OneginiWrapperErrors().authenticatedUserProfileIsNull.code, OneginiWrapperErrors().authenticatedUserProfileIsNull.message, null)
            return
        }
        if (authenticatedUserProfile.let { userClient.isUserEnrolledForMobileAuth(it) }) {
            handleMobileAuthWithOtp(context,data, result)
        } else {
            enrollMobileAuthentication(context,data, result)
        }


    }
    private fun handleMobileAuthWithOtp(context:Context,data: String, result: MethodChannel.Result) {
        OneginiSDK().getOneginiClient(context).userClient.handleMobileAuthWithOtp(data
                , object : OneginiMobileAuthWithOtpHandler {
            override fun onSuccess() {
                result.success("success auth with otp")
            }

            override fun onError(p0: OneginiMobileAuthWithOtpError) {
                result.error(p0.errorType.toString(), p0.message, null)
            }
        })
    }

    private fun enrollMobileAuthentication(context:Context,data: String, result: MethodChannel.Result) {
        OneginiSDK().getOneginiClient(context).userClient.enrollUserForMobileAuth(object : OneginiMobileAuthEnrollmentHandler {
            override fun onSuccess() {
                handleMobileAuthWithOtp(context,data, result)
            }

            override fun onError(p0: OneginiMobileAuthEnrollmentError) {
                result.error(p0.errorType.toString(), p0.message, null)
            }

        })
    }

}