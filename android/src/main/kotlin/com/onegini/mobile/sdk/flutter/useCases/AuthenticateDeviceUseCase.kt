package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AuthenticateDeviceUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val scope = call.argument<ArrayList<String>>("scope")
        oneginiClient.deviceClient.authenticateDevice(scope?.toArray(arrayOfNulls<String>(scope.size)), object : OneginiDeviceAuthenticationHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiDeviceAuthenticationError) {
                SdkError(
                    code = error.errorType,
                    message = error.message
                ).flutterError(result)
            }
        }
        )
    }
}