package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OneginiMethodsWrapper @Inject constructor(
    private val getImplicitResourceUseCase: GetImplicitResourceUseCase,
    private val getResourceAnonymousUseCase: GetResourceAnonymousUseCase,
    private val getResourceUseCase: GetResourceUseCase,
    private val getUnauthenticatedResourceUseCase: GetUnauthenticatedResourceUseCase,
    private val isAuthenticatorRegisteredUseCase: IsAuthenticatorRegisteredUseCase,
    private val resourceHelper: ResourceHelper,
    private val startAppUseCase: StartAppUseCase,
    private val changePinUseCase: ChangePinUseCase,
    private val validatePinWithPolicyUseCase: ValidatePinWithPolicyUseCase,
) {

    fun cancelBrowserRegistration() {
        BrowserRegistrationRequestHandler.onRegistrationCanceled()
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result) {
        startAppUseCase(call, result)
    }

    fun getResourceAnonymous(call: MethodCall, result: MethodChannel.Result){
        getResourceAnonymousUseCase(call, result, resourceHelper)
    }

    fun getResource(call: MethodCall, result: MethodChannel.Result){
        getResourceUseCase(call, result, resourceHelper)
    }

    fun getImplicitResource(call: MethodCall, result: MethodChannel.Result){
        getImplicitResourceUseCase(call, result, resourceHelper)
    }

    fun getUnauthenticatedResource(call: MethodCall, result: MethodChannel.Result){
        getUnauthenticatedResourceUseCase(call, result, resourceHelper)
    }

    fun isAuthenticatorRegistered(call: MethodCall, result: MethodChannel.Result) {
        isAuthenticatorRegisteredUseCase(call, result)
    }

    fun validatePinWithPolicy(call: MethodCall, result: MethodChannel.Result) {
        validatePinWithPolicyUseCase(call, result)
    }
}
