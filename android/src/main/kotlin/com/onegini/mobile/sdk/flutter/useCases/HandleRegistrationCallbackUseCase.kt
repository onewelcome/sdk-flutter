package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HandleRegistrationCallbackUseCase @Inject constructor(private val uriFacade: UriFacade, private val registrationRequestHandler: BrowserRegistrationRequestHandler) {
  operator fun invoke(url: String): Result<Unit> {
    val uri = uriFacade.parse(url)
    return registrationRequestHandler.handleRegistrationCallback(uri)
  }
}
