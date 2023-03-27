package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAppToWebSingleSignOn
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAppToWebSingleSignOnUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val uriFacade: UriFacade) {
    operator fun invoke(url: String, callback: (Result<OWAppToWebSingleSignOn>) -> Unit) {
        val targetUri = uriFacade.parse(url)
        oneginiSDK.oneginiClient.userClient.getAppToWebSingleSignOn(
            targetUri,
            object : OneginiAppToWebSingleSignOnHandler {
                override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                    callback(
                        Result.success(
                            OWAppToWebSingleSignOn(
                                oneginiAppToWebSingleSignOn.token,
                                oneginiAppToWebSingleSignOn.redirectUrl.toString()
                            )
                        )
                    )
                }

                override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                    callback(
                        Result.failure(
                            SdkError(
                                code = oneginiSingleSignOnError.errorType,
                                message = oneginiSingleSignOnError.message
                            ).pigeonError()
                        )
                    )
                }
            }
        )
    }
}
