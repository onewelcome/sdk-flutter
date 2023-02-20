package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAccessTokenUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        val accessToken = oneginiSDK.oneginiClient.userClient.accessToken
        result.success(accessToken)
    }
}
