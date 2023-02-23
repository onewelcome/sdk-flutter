package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class CancelCustomRegistrationActionUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(result: MethodChannel.Result, call: MethodCall) {
    val idProvider: String? = call.argument("identityProviderId")

    when (val action = oneginiSDK.getCustomRegistrationActions().find { it.getIdProvider() == idProvider }) {
      null -> SdkError(IDENTITY_PROVIDER_NOT_FOUND).flutterError(result)
      else -> {
        when (val error: String? = call.argument("error")) {
          null -> action.returnError(null, result)
          else -> action.returnError(Exception(error), result)
        }
      }
    }
  }
}
