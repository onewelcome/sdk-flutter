package com.onegini.mobile.sdk.flutter.useCases

import android.net.Uri
import android.util.Patterns
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class GetAppToWebSingleSignOnUseCase(private var oneginiClient: OneginiClient) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url")
        if (url == null) {
            result.error(OneginiWrapperErrors.URL_CANT_BE_NULL.code, OneginiWrapperErrors.URL_CANT_BE_NULL.message, null)
            return
        }
        if (!Patterns.WEB_URL.matcher(url).matches()) {
            result.error(OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.code, OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.message, null)
            return
        }
        val targetUri: Uri = Uri.parse(url)
        oneginiClient.userClient.getAppToWebSingleSignOn(
                targetUri,
                object : OneginiAppToWebSingleSignOnHandler {
                    override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                        result.success(Gson().toJson(mapOf("token" to oneginiAppToWebSingleSignOn.token, "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl.toString())))
                    }

                    override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                        result.error(oneginiSingleSignOnError.errorType.toString(), oneginiSingleSignOnError.message, null)
                    }
                }
        )
    }
}