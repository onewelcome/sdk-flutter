package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetRedirectUrlUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        result.success(oneginiSDK.oneginiClient.configModel.redirectUri)
    }
}
