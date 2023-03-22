package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OneginiMethodsWrapper @Inject constructor(
    private val isAuthenticatorRegisteredUseCase: IsAuthenticatorRegisteredUseCase,
    private val startAppUseCase: StartAppUseCase,
) {

    fun cancelBrowserRegistration() {
        BrowserRegistrationRequestHandler.onRegistrationCanceled()
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result) {
        startAppUseCase(call, result)
    }

    fun isAuthenticatorRegistered(call: MethodCall, result: MethodChannel.Result) {
        isAuthenticatorRegisteredUseCase(call, result)
    }
}
