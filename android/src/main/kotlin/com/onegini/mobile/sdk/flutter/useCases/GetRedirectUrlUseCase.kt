package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import io.flutter.plugin.common.MethodChannel

class GetRedirectUrlUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val redirectUrl = oneginiClient.configModel.redirectUri
        result.success(redirectUrl)
    }
}
