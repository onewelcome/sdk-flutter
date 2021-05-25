package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiFingerprintCallback
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.flutter.useCases.HandleRegisteredUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapper {

    fun registerUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegistrationUseCase(oneginiClient)(call, result)
    }

    fun handleRegisteredUrl(call: MethodCall, context: Context) {
        HandleRegisteredUrlUseCase()(call, context)
    }

    fun getIdentityProviders(result: MethodChannel.Result, oneginiClient: OneginiClient){
        GetIdentityProvidersUseCase(oneginiClient)(result)
    }

    fun getAccessToken(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetAccessTokenUseCase(oneginiClient)(result)
    }

    fun cancelRegistration(){
        RegistrationRequestHandler.onRegistrationCanceled()
    }

    fun getAuthenticatedUserProfile(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetAuthenticatedUserProfileUseCase(oneginiClient)(result)
    }

    fun getUserProfiles(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetUserProfilesUseCase(oneginiClient)(result)
    }

    fun startApp(call: MethodCall,result: MethodChannel.Result,context: Context){
        StartAppUseCase(context,OneginiSDK())(call,result)
    }

    fun getAllAuthenticators(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetAllAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun customTwoStepRegistrationActionReturnSuccess(call: MethodCall,oneginiCustomRegistrationCallback: OneginiCustomRegistrationCallback?) {
        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnSuccess(call)
    }

    fun customTwoStepRegistrationActionReturnError(call: MethodCall,oneginiCustomRegistrationCallback: OneginiCustomRegistrationCallback?) {
        CustomTwoStepRegistrationActionUseCase(oneginiCustomRegistrationCallback).returnError(call)
    }

    fun pinRequestHandlerAcceptAuthenticationRequest(call: MethodCall,oneginiPinCallback: OneginiPinCallback?){
        PinRequestHandlerUseCase(oneginiPinCallback).acceptAuthenticationRequest(call)
    }

    fun pinRequestHandlerDenyAuthenticationRequest(oneginiPinCallback: OneginiPinCallback?){
        PinRequestHandlerUseCase(oneginiPinCallback).denyAuthenticationRequest()
    }

    fun pinAuthenticationRequestHandlerAcceptAuthenticationRequest(call: MethodCall,oneginiPinCallback: OneginiPinCallback?){
        PinAuthenticationRequestHandlerUseCase(oneginiPinCallback).acceptAuthenticationRequest(call)
    }

    fun pinAuthenticationRequestHandlerDenyAuthenticationRequest(oneginiPinCallback: OneginiPinCallback?){
        PinAuthenticationRequestHandlerUseCase(oneginiPinCallback).denyAuthenticationRequest()
    }

    fun fingerprintAuthenticationRequestHandlerAcceptAuthenticationRequest(oneginiFingerprintCallback: OneginiFingerprintCallback?) {
        FingerprintAuthenticationRequestHandlerUseCase(oneginiFingerprintCallback).acceptAuthenticationRequest()
    }

    fun fingerprintAuthenticationRequestHandlerDenyAuthenticationRequest(oneginiFingerprintCallback: OneginiFingerprintCallback?) {
        FingerprintAuthenticationRequestHandlerUseCase(oneginiFingerprintCallback).denyAuthenticationRequest()
    }

    fun fingerprintAuthenticationRequestHandlerFallbackToPin(oneginiFingerprintCallback: OneginiFingerprintCallback?) {
        FingerprintAuthenticationRequestHandlerUseCase(oneginiFingerprintCallback).fallbackToPin()
    }

    fun mobileAuthOtpRequestHandlerAcceptAuthenticationRequest(oneginiAcceptDenyCallback: OneginiAcceptDenyCallback?) {
        MobileAuthOtpRequestHandlerUseCase(oneginiAcceptDenyCallback).acceptAuthenticationRequest()
    }

    fun mobileAuthOtpRequestHandlerDenyAuthenticationRequest(oneginiAcceptDenyCallback: OneginiAcceptDenyCallback?) {
        MobileAuthOtpRequestHandlerUseCase(oneginiAcceptDenyCallback).denyAuthenticationRequest()
    }
}