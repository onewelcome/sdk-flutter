package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.UNAUTHENTICATED_IMPLICITLY
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient

class GetImplicitResourceUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result, resourceHelper: ResourceHelper) {
        when (oneginiClient.userClient.implicitlyAuthenticatedUserProfile) {
            null -> SdkError(UNAUTHENTICATED_IMPLICITLY).flutterError(result)
            else -> {
                val okHttpClient: OkHttpClient = oneginiClient.userClient.implicitResourceOkHttpClient
                val resourceBaseUrl = oneginiClient.configModel.resourceBaseUrl
                val request = resourceHelper.getRequest(call, resourceBaseUrl)
                resourceHelper.callRequest(okHttpClient, request, result)
            }
        }
    }
}
