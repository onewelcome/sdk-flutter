package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticateDeviceUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    val sdkScopes: Array<String>? = scopes?.toTypedArray()

    oneginiSDK.oneginiClient.deviceClient.authenticateDevice(sdkScopes, object : OneginiDeviceAuthenticationHandler {
      override fun onSuccess() {
        callback(Result.success(Unit))
      }

      override fun onError(error: OneginiDeviceAuthenticationError) {
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
