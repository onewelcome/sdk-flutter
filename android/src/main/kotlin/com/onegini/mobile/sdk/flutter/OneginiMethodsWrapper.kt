package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.useCases.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OneginiMethodsWrapper @Inject constructor(
    private val authenticateDeviceUseCase: AuthenticateDeviceUseCase,
    private val authenticateUserImplicitlyUseCase: AuthenticateUserImplicitlyUseCase,
    private val authenticateUserUseCase: AuthenticateUserUseCase,
    private val cancelCustomRegistrationActionUseCase: CancelCustomRegistrationActionUseCase,
    private val deregisterAuthenticatorUseCase: DeregisterAuthenticatorUseCase,
    private val deregisterUserUseCase: DeregisterUserUseCase,
    private val getAccessTokenUseCase: GetAccessTokenUseCase,
    private val getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase,
    private val getAuthenticatedUserProfileUseCase: GetAuthenticatedUserProfileUseCase,
    private val getIdentityProvidersUseCase: GetIdentityProvidersUseCase,
    private val getImplicitResourceUseCase: GetImplicitResourceUseCase,
    private val getNotRegisteredAuthenticatorsUseCase: GetNotRegisteredAuthenticatorsUseCase,
    private val getRedirectUrlUseCase: GetRedirectUrlUseCase,
    private val getRegisteredAuthenticatorsUseCase: GetRegisteredAuthenticatorsUseCase,
    private val getResourceAnonymousUseCase: GetResourceAnonymousUseCase,
    private val getResourceUseCase: GetResourceUseCase,
    private val getUnauthenticatedResourceUseCase: GetUnauthenticatedResourceUseCase,
    private val getUserProfilesUseCase: GetUserProfilesUseCase,
    private val handleRegisteredUrlUseCase: HandleRegisteredUrlUseCase,
    private val isAuthenticatorRegisteredUseCase: IsAuthenticatorRegisteredUseCase,
    private val logoutUseCase: LogoutUseCase,
    private val registerAuthenticatorUseCase: RegisterAuthenticatorUseCase,
    private val registrationUseCase: RegistrationUseCase,
    private val setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase,
    private val startAppUseCase: StartAppUseCase,
    private val submitCustomRegistrationActionUseCase: SubmitCustomRegistrationActionUseCase
) {

    fun registerUser(call: MethodCall, result: MethodChannel.Result) {
        registrationUseCase(call, result)
    }

    fun respondCustomRegistrationAction(
        call: MethodCall,
        result: MethodChannel.Result) {
        submitCustomRegistrationActionUseCase(result, call)
    }

    fun cancelCustomRegistrationAction(
        call: MethodCall,
        result: MethodChannel.Result) {
        cancelCustomRegistrationActionUseCase(result, call)
    }

    fun handleRegisteredUrl(call: MethodCall, oneginiClient: OneginiClient) {
        handleRegisteredUrlUseCase(call)
    }

    fun getIdentityProviders(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getIdentityProvidersUseCase(result)
    }

    fun getAccessToken(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getAccessTokenUseCase(result)
    }

    fun cancelBrowserRegistration() {
        BrowserRegistrationRequestHandler.onRegistrationCanceled()
    }

    fun getAuthenticatedUserProfile(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getAuthenticatedUserProfileUseCase(result)
    }

    fun getUserProfiles(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getUserProfilesUseCase(result)
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result, oneginiSDK: OneginiSDK) {
        startAppUseCase(call, result)
    }

    fun getRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getRegisteredAuthenticatorsUseCase(result)
    }

    fun getNotRegisteredAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getNotRegisteredAuthenticatorsUseCase(result)
    }

    fun setPreferredAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        setPreferredAuthenticatorUseCase(call, result)
    }

    fun deregisterUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        deregisterUserUseCase(call, result)
    }

    fun deregisterAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        deregisterAuthenticatorUseCase(call, result)
    }

    fun registerAuthenticator(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        registerAuthenticatorUseCase(call, result)
    }

    fun getAllAuthenticators(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        getAllAuthenticatorsUseCase(result)
    }

    fun getRedirectUrl(result: MethodChannel.Result,oneginiClient: OneginiClient) {
        getRedirectUrlUseCase(result)
    }

    fun authenticateUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        authenticateUserUseCase(call, result)
    }

    fun authenticateDevice(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        authenticateDeviceUseCase(call, result)
    }

    fun authenticateUserImplicitly(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient){
        authenticateUserImplicitlyUseCase(call, result)
    }

    fun getResourceAnonymous(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        getResourceAnonymousUseCase(call, result, resourceHelper)
    }

    fun getResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        getResourceUseCase(call, result, resourceHelper)
    }

    fun getImplicitResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        getImplicitResourceUseCase(call, result, resourceHelper)
    }

    fun getUnauthenticatedResource(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient, resourceHelper: ResourceHelper){
        getUnauthenticatedResourceUseCase(call, result, resourceHelper)
    }

    fun isAuthenticatorRegistered(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        isAuthenticatorRegisteredUseCase(call, result)
    }

    fun logout(result: MethodChannel.Result,oneginiClient: OneginiClient) {
        logoutUseCase(result)
    }
}
