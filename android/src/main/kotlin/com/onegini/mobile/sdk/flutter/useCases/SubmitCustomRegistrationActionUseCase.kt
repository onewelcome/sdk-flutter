package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND
import com.onegini.mobile.sdk.flutter.handlers.CustomRegistrationHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class SubmitCustomRegistrationActionUseCase(private val customRegistrationActions: ArrayList<CustomRegistrationAction>) {
  operator fun invoke(result: MethodChannel.Result, call: MethodCall) {
    val idProvider: String? = call.argument("identityProviderId")
    val token: String? = call.argument("token")

    when (val action = CustomRegistrationHandler().getCustomRegistrationAction(idProvider, customRegistrationActions)) {
      null -> SdkError(IDENTITY_PROVIDER_NOT_FOUND).flutterError(result)
      else -> action.returnSuccess(token, result)
    }
  }
}
