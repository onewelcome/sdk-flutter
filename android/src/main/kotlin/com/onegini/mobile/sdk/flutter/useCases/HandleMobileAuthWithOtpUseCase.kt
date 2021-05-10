package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HandleMobileAuthWithOtpUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val data = call.argument<String>("data")
        if (data == null) {
            result.error(OneginiWrapperErrors.QR_CODE_NOT_HAVE_DATA.code, OneginiWrapperErrors.QR_CODE_NOT_HAVE_DATA.message, null)
            return
        }
        oneginiClient.userClient.handleMobileAuthWithOtp(data, object : OneginiMobileAuthWithOtpHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiMobileAuthWithOtpError: OneginiMobileAuthWithOtpError) {
                result.error(oneginiMobileAuthWithOtpError.errorType.toString(), oneginiMobileAuthWithOtpError.message, null)
            }
        }
        )
    }
}