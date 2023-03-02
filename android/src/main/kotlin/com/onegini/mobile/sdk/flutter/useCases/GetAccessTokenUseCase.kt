package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAccessTokenUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        oneginiSDK.oneginiClient.userClient.accessToken?.let { token ->
            result.success(token)
            return
        }
        result.wrapperError(NO_USER_PROFILE_IS_AUTHENTICATED)
    }
}
