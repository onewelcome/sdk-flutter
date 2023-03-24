package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.METHOD_TO_CALL_NOT_FOUND
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject

class OnMethodCallMapper @Inject constructor(private val oneginiSDK: OneginiSDK) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, oneginiSDK.oneginiClient)
            else -> SdkError(METHOD_TO_CALL_NOT_FOUND).flutterError(result)
        }
    }
}
