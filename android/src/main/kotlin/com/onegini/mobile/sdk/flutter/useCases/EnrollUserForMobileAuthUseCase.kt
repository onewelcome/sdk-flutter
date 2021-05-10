package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthEnrollmentHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthEnrollmentError
import io.flutter.plugin.common.MethodChannel

class EnrollUserForMobileAuthUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        oneginiClient.userClient.enrollUserForMobileAuth(object : OneginiMobileAuthEnrollmentHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(oneginiMobileAuthEnrollmentError: OneginiMobileAuthEnrollmentError) {
                result.error(oneginiMobileAuthEnrollmentError.errorType.toString(), oneginiMobileAuthEnrollmentError.message, null)
            }
        })
    }
}