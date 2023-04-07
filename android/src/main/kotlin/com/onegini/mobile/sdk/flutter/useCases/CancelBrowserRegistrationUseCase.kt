package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import javax.inject.Inject

class CancelBrowserRegistrationUseCase @Inject constructor(private val browserRegistrationRequestHandler: BrowserRegistrationRequestHandler) {
  operator fun invoke(): Result<Unit> {
    return browserRegistrationRequestHandler.cancelRegistration()
  }
}
