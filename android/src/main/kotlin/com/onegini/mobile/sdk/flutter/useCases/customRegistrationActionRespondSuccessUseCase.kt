package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.handlers.CustomRegistrationHandler
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class customRegistrationActionRespondSuccessUseCase(private val customRegistrationActions: ArrayList<CustomRegistrationAction>) {
  operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
    val idProvider: String? = call.argument("identityProviderId")
    val token: String? = call.argument("token")

    val action = CustomRegistrationHandler().getCustomRegistrationAction(idProvider, customRegistrationActions)

    when {
      action != null ->  action.returnSuccess(token)
      else -> return // TODO throw new custom platform exception "no provider found" with that id once FP-16 is merged
    }
  }
}