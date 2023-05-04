package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL
import javax.inject.Inject

class CancelBrowserRegistrationUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return when (val browserCallback = BrowserRegistrationRequestHandler.callback) {
      null -> Result.failure(SdkError(ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL).pigeonError())
      else -> {
        browserCallback.denyRegistration()
        BrowserRegistrationRequestHandler.callback = null
        Result.success(Unit)
      }
    }
  }
}
