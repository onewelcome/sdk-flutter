package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthWithOtpHandler
import com.onegini.mobile.sdk.android.handlers.OneginiMobileAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthWithOtpError
import com.onegini.mobile.sdk.android.handlers.error.OneginiMobileAuthenticationError
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthWithPushRequest
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOnegini
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWPendingMobileAuthRequest
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HandleMobileAuthWithPushUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
) {
  operator fun invoke(request: OWPendingMobileAuthRequest, callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.handleMobileAuthWithPushRequest(
      request.toOnegini(),
      object : OneginiMobileAuthenticationHandler {
        override fun onSuccess(customInfo: CustomInfo?) {
          // FIXME: send back customInfo
          callback(Result.success(Unit))
        }

        override fun onError(error: OneginiMobileAuthenticationError) {
          callback(
            Result.failure(
              SdkError(
                code = error.errorType,
                message = error.message
              ).pigeonError()
            )
          )
        }
      }
    )
  }
}
