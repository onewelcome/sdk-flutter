package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.USER_NOT_AUTHENTICATED_IMPLICITLY
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetImplicitResourceUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result, resourceHelper: ResourceHelper) {
        when (oneginiSDK.oneginiClient.userClient.implicitlyAuthenticatedUserProfile) {
            null -> SdkError(USER_NOT_AUTHENTICATED_IMPLICITLY).flutterError(result)
            else -> {
                val okHttpClient: OkHttpClient = oneginiSDK.oneginiClient.userClient.implicitResourceOkHttpClient
                val resourceBaseUrl = oneginiSDK.oneginiClient.configModel.resourceBaseUrl
                val request = resourceHelper.getRequest(call, resourceBaseUrl)
                resourceHelper.callRequest(okHttpClient, request, result)
            }
        }
    }
}
