package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient

class GetResourceAnonymousUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result, resourceHelper: ResourceHelper) {
        val okHttpClient: OkHttpClient = oneginiClient.deviceClient.anonymousResourceOkHttpClient
        val resourceBaseUrl = oneginiClient.configModel.resourceBaseUrl
        val request = resourceHelper.getRequest(call, resourceBaseUrl)
        resourceHelper.callRequest(okHttpClient, request, result)
    }
}