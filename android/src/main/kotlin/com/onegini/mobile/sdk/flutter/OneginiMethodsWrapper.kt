package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapper {

    fun registerUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegistrationUseCase(oneginiClient)(call, result)
    }

    fun respondCustomRegistrationAction(
        call: MethodCall,
        result: MethodChannel.Result,
        customRegistrationActions: ArrayList<CustomRegistrationAction>) {
        SubmitCustomRegistrationActionUseCase(customRegistrationActions)(result, call)
    }

    fun cancelCustomRegistrationAction(
        call: MethodCall,
        result: MethodChannel.Result,
        customRegistrationActions: ArrayList<CustomRegistrationAction>) {
        CancelCustomRegistrationActionUseCase(customRegistrationActions)(result, call)
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

    fun cancelBrowserRegistration() {
        BrowserRegistrationRequestHandler.onRegistrationCanceled()
    }

    fun getAuthenticatedUserProfile(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetAuthenticatedUserProfileUseCase(oneginiClient)(result)
    }

    fun fetchUserProfiles(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        FetchUserProfilesUseCase(oneginiClient)(result)
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result, oneginiSDK: OneginiSDK, context: Context) {
        StartAppUseCase(context, oneginiSDK)(call, result)
    }

    fun getRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetRegisteredAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun getNotRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetNotRegisteredAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun setPreferredAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        SetPreferredAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun deregisterUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        DeregisterUserUseCase(oneginiClient)(call, result)
    }

    fun deregisterAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        DeregisterAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun registerAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegisterAuthenticatorUseCase(oneginiClient)(call, result)
    }

    fun getAllAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        GetAllAuthenticatorsUseCase(oneginiClient)(result)
    }

    fun getRedirectUrl(result: MethodChannel.Result,oneginiClient: OneginiClient) {
        GetRedirectUrlUseCase(oneginiClient)(result)
    }

    fun authenticateUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        AuthenticateUserUseCase(oneginiClient)(call, result)
    }

    fun authenticateDevice(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        AuthenticateDeviceUseCase(oneginiClient)(call, result)
    }

    fun authenticateUserImplicitly(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        AuthenticateUserImplicitlyUseCase(oneginiClient)(call, result)
    }

    fun getResourceAnonymous(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        GetResourceAnonymousUseCase(oneginiClient)(call, result, resourceHelper)
    }

    fun getResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        GetResourceUseCase(oneginiClient)(call, result, resourceHelper)
    }

    fun getImplicitResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        GetImplicitResourceUseCase(oneginiClient)(call, result, resourceHelper)
    }

    fun getUnauthenticatedResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        GetUnauthenticatedResourceUseCase(oneginiClient)(call, result, resourceHelper)
    }

    fun isAuthenticatorRegistered(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        IsAuthenticatorRegisteredUseCase(oneginiClient)(call, result)
    }

    fun logout(result: MethodChannel.Result,oneginiClient: OneginiClient) {
        LogoutUseCase(oneginiClient)(result)
    }
}
