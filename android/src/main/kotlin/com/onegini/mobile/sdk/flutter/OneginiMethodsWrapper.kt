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
    private val resourceHelper: ResourceHelper,
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

    fun handleRegisteredUrl(call: MethodCall) {
        handleRegisteredUrlUseCase(call)
    }

    fun getIdentityProviders(result: MethodChannel.Result) {
        getIdentityProvidersUseCase(result)
    }

    fun getAccessToken(result: MethodChannel.Result) {
        getAccessTokenUseCase(result)
    }

    fun cancelBrowserRegistration() {
        BrowserRegistrationRequestHandler.onRegistrationCanceled()
    }

    fun getAuthenticatedUserProfile(result: MethodChannel.Result) {
        getAuthenticatedUserProfileUseCase(result)
    }

    fun getUserProfiles(result: MethodChannel.Result) {
        getUserProfilesUseCase(result)
    }

    fun startApp(call: MethodCall, result: MethodChannel.Result) {
        startAppUseCase(call, result)
    }

    fun getRegisteredAuthenticators(call: MethodCall, result: MethodChannel.Result) {
        getRegisteredAuthenticatorsUseCase(call, result)
    }

    fun getNotRegisteredAuthenticators(result: MethodChannel.Result) {
        getNotRegisteredAuthenticatorsUseCase(result)
    }

    fun setPreferredAuthenticator(call: MethodCall, result: MethodChannel.Result) {
        setPreferredAuthenticatorUseCase(call, result)
    }

    fun deregisterUser(call: MethodCall, result: MethodChannel.Result) {
        deregisterUserUseCase(call, result)
    }

    fun deregisterAuthenticator(call: MethodCall, result: MethodChannel.Result) {
        deregisterAuthenticatorUseCase(call, result)
    }

    fun registerAuthenticator(call: MethodCall, result: MethodChannel.Result) {
        registerAuthenticatorUseCase(call, result)
    }

    fun getAllAuthenticators(result: MethodChannel.Result) {
        getAllAuthenticatorsUseCase(result)
    }

    fun getRedirectUrl(result: MethodChannel.Result) {
        getRedirectUrlUseCase(result)
    }

    fun authenticateUser(call: MethodCall, result: MethodChannel.Result) {
        authenticateUserUseCase(call, result)
    }

    fun authenticateDevice(call: MethodCall, result: MethodChannel.Result){
        authenticateDeviceUseCase(call, result)
    }

    fun authenticateUserImplicitly(call: MethodCall, result: MethodChannel.Result){
        authenticateUserImplicitlyUseCase(call, result)
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

    fun logout(result: MethodChannel.Result) {
        logoutUseCase(result)
    }
}
