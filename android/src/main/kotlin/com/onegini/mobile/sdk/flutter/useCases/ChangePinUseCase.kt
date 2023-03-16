package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ChangePinUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.changePin(object : OneginiChangePinHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(error: OneginiChangePinError) {
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
