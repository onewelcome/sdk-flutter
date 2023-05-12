package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiDenyMobileAuthWithPushRequestHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDenyMobileAuthWithPushRequestError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOnegini
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWMobileAuthWithPushRequest
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DenyMobileAuthWithPushRequestUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
) {
  operator fun invoke(request: OWMobileAuthWithPushRequest, callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.denyMobileAuthWithPushRequest(request.toOnegini(), object: OneginiDenyMobileAuthWithPushRequestHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(error: OneginiDenyMobileAuthWithPushRequestError) {
        callback(
          Result.failure(
            SdkError(
              code = error.errorType,
              message = error.message
            ).pigeonError()
          )
        )
      }
    })
  }
}
