package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class LogoutUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(callback: (Result<Unit>) -> Unit) {
    oneginiSDK.oneginiClient.userClient.logout(object : OneginiLogoutHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(error: OneginiLogoutError) {
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
