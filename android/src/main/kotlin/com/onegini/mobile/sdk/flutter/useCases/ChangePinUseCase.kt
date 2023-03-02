package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ChangePinUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        oneginiSDK.oneginiClient.userClient.changePin(object : OneginiChangePinHandler {
            override fun onSuccess() {
                result.success(null)
            }

            override fun onError(error: OneginiChangePinError) {
                SdkError(
                    code = error.errorType,
                    message = error.message
                ).flutterError(result)
            }
        })
    }
}
