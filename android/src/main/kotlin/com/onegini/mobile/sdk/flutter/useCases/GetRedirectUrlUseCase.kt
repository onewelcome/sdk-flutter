package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetRedirectUrlUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(): Result<String> {
        return Result.success(oneginiSDK.oneginiClient.configModel.redirectUri)
    }
}
