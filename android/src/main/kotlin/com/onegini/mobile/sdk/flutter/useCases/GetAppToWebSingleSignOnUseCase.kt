package com.onegini.mobile.sdk.flutter.useCases

import android.util.Patterns
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.MALFORMED_URL
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.URL_CANT_BE_NULL
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAppToWebSingleSignOnUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val uriFacade: UriFacade) {
    operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val url = call.argument<String>("url") ?: return SdkError(URL_CANT_BE_NULL).flutterError(result)
        val targetUri = uriFacade.parse(url)
        oneginiSDK.oneginiClient.userClient.getAppToWebSingleSignOn(
            targetUri,
            object : OneginiAppToWebSingleSignOnHandler {
                override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                    result.success(
                        Gson().toJson(
                            mapOf(
                                "token" to oneginiAppToWebSingleSignOn.token,
                                "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl.toString()
                            )
                        )
                    )
                }

                override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                    SdkError(
                        code = oneginiSingleSignOnError.errorType,
                        message = oneginiSingleSignOnError.message
                    ).flutterError(result)
                }
            }
        )
    }
}
