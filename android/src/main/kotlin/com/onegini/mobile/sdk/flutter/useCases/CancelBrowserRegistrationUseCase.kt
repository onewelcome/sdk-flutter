package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.BROWSER_REGISTRATION_NOT_IN_PROGRESS
import javax.inject.Inject

class CancelBrowserRegistrationUseCase @Inject constructor() {
  operator fun invoke(): Result<Unit> {
    return when (val browserCallback = BrowserRegistrationRequestHandler.callback) {
      null -> Result.failure(SdkError(BROWSER_REGISTRATION_NOT_IN_PROGRESS).pigeonError())
      else -> {
        browserCallback.denyRegistration()
        BrowserRegistrationRequestHandler.callback = null
        Result.success(Unit)
      }
    }
  }
}
