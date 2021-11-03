package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapper {

    fun registerUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegistrationUseCase(oneginiClient)(call, result)
    }

    fun handleRegisteredUrl(call: MethodCall, context: Context, oneginiClient: OneginiClient) {
        HandleRegisteredUrlUseCase(oneginiClient)(call, context)
    }

    fun getIdentityProviders(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetIdentityProvidersUseCase(oneginiClient)(result)
    }

    fun getAccessToken(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetAccessTokenUseCase(oneginiClient)(result)
    }

    fun cancelRegistration() {
        RegistrationRequestHandler.onRegistrationCanceled()
    }

    fun getAuthenticatedUserProfile(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetAuthenticatedUserProfileUseCase(oneginiClient)(result)
    }

    fun getUserProfiles(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetUserProfilesUseCase(oneginiClient)(result)
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result, oneginiSDK: OneginiSDK, context: Context) {
        StartAppUseCase(context, oneginiSDK)(call, result)
    }

    fun getRegisteredAuthenticators(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetRegisteredAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun getNotRegisteredAuthenticators(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetNotRegisteredAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun setPreferredAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        SetPreferredAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun deregisterUser(call: MethodCall,result: MethodChannel.Result,oneginiClient: OneginiClient){
        DeregisterUserUseCase(oneginiClient)(call,result)
    }

    fun deregisterAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        DeregisterAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun registerAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegisterAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun getAllAuthenticators(result: MethodChannel.Result,oneginiClient: OneginiClient){
        GetAllAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun authenticateUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        AuthenticateUserUseCase(oneginiClient)(call, result)
    }
}