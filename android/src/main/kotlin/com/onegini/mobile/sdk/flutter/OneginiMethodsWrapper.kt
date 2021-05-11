package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
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

    fun isAuthenticatorRegistered(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        IsAuthenticatorRegisteredUseCase(oneginiClient)(call, result)
    }
}