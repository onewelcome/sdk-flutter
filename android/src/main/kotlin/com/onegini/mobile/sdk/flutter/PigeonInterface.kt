package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateDeviceUseCase
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserImplicitlyUseCase
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.CancelCustomRegistrationActionUseCase
import com.onegini.mobile.sdk.flutter.useCases.ChangePinUseCase
import com.onegini.mobile.sdk.flutter.useCases.DeregisterAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.DeregisterUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAccessTokenUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAuthenticatedUserProfileUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetIdentityProvidersUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetImplicitResourceUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetNotRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetRedirectUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetResourceAnonymousUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetResourceUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUnauthenticatedResourceUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfilesUseCase
import com.onegini.mobile.sdk.flutter.useCases.HandleRegisteredUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.IsAuthenticatorRegisteredUseCase
import com.onegini.mobile.sdk.flutter.useCases.LogoutUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegisterAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import com.onegini.mobile.sdk.flutter.useCases.SubmitCustomRegistrationActionUseCase
import javax.inject.Inject

//private val getIdentityProvidersUseCase: GetIdentityProvidersUseCase
open class PigeonInterface : UserClientApi {
  @Inject
  lateinit var authenticateDeviceUseCase: AuthenticateDeviceUseCase
  @Inject
  lateinit var authenticateUserImplicitlyUseCase: AuthenticateUserImplicitlyUseCase
  @Inject
  lateinit var authenticateUserUseCase: AuthenticateUserUseCase
  @Inject
  lateinit var cancelCustomRegistrationActionUseCase: CancelCustomRegistrationActionUseCase
  @Inject
  lateinit var deregisterAuthenticatorUseCase: DeregisterAuthenticatorUseCase
  @Inject
  lateinit var deregisterUserUseCase: DeregisterUserUseCase
  @Inject
  lateinit var getAccessTokenUseCase: GetAccessTokenUseCase
  @Inject
  lateinit var getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase
  @Inject
  lateinit var getAuthenticatedUserProfileUseCase: GetAuthenticatedUserProfileUseCase
  @Inject
  lateinit var getIdentityProvidersUseCase: GetIdentityProvidersUseCase
  @Inject
  lateinit var getImplicitResourceUseCase: GetImplicitResourceUseCase
  @Inject
  lateinit var getNotRegisteredAuthenticatorsUseCase: GetNotRegisteredAuthenticatorsUseCase
  @Inject
  lateinit var getRedirectUrlUseCase: GetRedirectUrlUseCase
  @Inject
  lateinit var getRegisteredAuthenticatorsUseCase: GetRegisteredAuthenticatorsUseCase
  @Inject
  lateinit var getResourceAnonymousUseCase: GetResourceAnonymousUseCase
  @Inject
  lateinit var getResourceUseCase: GetResourceUseCase
  @Inject
  lateinit var getUnauthenticatedResourceUseCase: GetUnauthenticatedResourceUseCase
  @Inject
  lateinit var getUserProfilesUseCase: GetUserProfilesUseCase
  @Inject
  lateinit var handleRegisteredUrlUseCase: HandleRegisteredUrlUseCase
  @Inject
  lateinit var isAuthenticatorRegisteredUseCase: IsAuthenticatorRegisteredUseCase
  @Inject
  lateinit var logoutUseCase: LogoutUseCase
  @Inject
  lateinit var registerAuthenticatorUseCase: RegisterAuthenticatorUseCase
  @Inject
  lateinit var registrationUseCase: RegistrationUseCase
  @Inject
  lateinit var resourceHelper: ResourceHelper
  @Inject
  lateinit var setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase
  @Inject
  lateinit var startAppUseCase: StartAppUseCase
  @Inject
  lateinit var submitCustomRegistrationActionUseCase: SubmitCustomRegistrationActionUseCase
  @Inject
  lateinit var changePinUseCase: ChangePinUseCase

  // FIXME REMOVE ME AT THE END; Example function on how it could be initiated on Flutter send to Native
  override fun fetchUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
    val a = Result.success(listOf(OWUserProfile("ghalo")))
//    flutterCallback(callback, a)

//    val b = Result.failure<List<OneWelcomeUserProfile>>(SdkError(2000, "hallo"))
//    flutterCallback(callback, b)
  }

  override fun registerUser(identityProviderId: String?, scopes: List<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    registrationUseCase(identityProviderId, scopes, callback)
  }

  override fun handleRegisteredUserUrl(url: String, signInType: Long, callback: (Result<Unit>) -> Unit) {
    callback(handleRegisteredUrlUseCase(url, signInType))
  }

  override fun getIdentityProviders(callback: (Result<List<OWIdentityProvider>>) -> Unit) {
    callback(getIdentityProvidersUseCase())
  }

  override fun deregisterUser(profileId: String, callback: (Result<Unit>) -> Unit) {
    deregisterUserUseCase(profileId, callback)
  }

  override fun getRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    callback(getRegisteredAuthenticatorsUseCase(profileId))
  }

  override fun getAllAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    callback(getAllAuthenticatorsUseCase(profileId))
  }

  override fun getAuthenticatedUserProfile(callback: (Result<OWUserProfile>) -> Unit) {
    callback(getAuthenticatedUserProfileUseCase())
  }

  override fun authenticateUser(profileId: String, registeredAuthenticatorId: String?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    authenticateUserUseCase(profileId, registeredAuthenticatorId, callback)
  }

  override fun getNotRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    callback(getNotRegisteredAuthenticatorsUseCase(profileId))
  }

  override fun changePin(callback: (Result<Unit>) -> Unit) {
    changePinUseCase(callback)
  }

  override fun setPreferredAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    callback(setPreferredAuthenticatorUseCase(authenticatorId))
  }

  override fun deregisterAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    deregisterAuthenticatorUseCase(authenticatorId, callback)
  }

  override fun registerAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    registerAuthenticatorUseCase(authenticatorId, callback)
  }

  override fun logout(callback: (Result<Unit>) -> Unit) {
    logoutUseCase(callback)
  }

  override fun mobileAuthWithOtp(data: String, callback: (Result<String?>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAppToWebSingleSignOn(url: String, callback: (Result<OWAppToWebSingleSignOn>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAccessToken(callback: (Result<String>) -> Unit) {
    callback(getAccessTokenUseCase())
  }

  override fun getRedirectUrl(callback: (Result<String>) -> Unit) {
    callback(getRedirectUrlUseCase())
  }

  override fun getUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
    callback(getUserProfilesUseCase())
  }

  override fun validatePinWithPolicy(pin: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun authenticateDevice(scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    authenticateDeviceUseCase(scopes, callback)
  }

  override fun authenticateUserImplicitly(profileId: String, scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    authenticateUserImplicitlyUseCase(profileId, scopes, callback)
  }

  // Callback functions
  override fun submitCustomRegistrationAction(identityProviderId: String, data: String?, callback: (Result<Unit>) -> Unit) {
    submitCustomRegistrationActionUseCase(identityProviderId, data, callback)
  }

  override fun cancelCustomRegistrationAction(identityProviderId: String, error: String, callback: (Result<Unit>) -> Unit) {
    cancelCustomRegistrationActionUseCase(identityProviderId, error, callback)
  }

  override fun fingerprintFallbackToPin(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    FingerprintAuthenticationRequestHandler.fingerprintCallback?.fallbackToPin()
    callback(Result.success(Unit))
  }

  override fun fingerprintDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun fingerprintAcceptAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun otpDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun otpAcceptAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun pinDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun pinAcceptAuthenticationRequest(pin: String, callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin.toCharArray())
    callback(Result.success(Unit))
  }

  override fun pinDenyRegistrationRequest(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
    callback(Result.success(Unit))
  }

  override fun pinAcceptRegistrationRequest(pin: String, callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin.toCharArray())
    callback(Result.success(Unit))
  }

  override fun cancelBrowserRegistration(callback: (Result<Unit>) -> Unit) {
    // TODO NEEDS OWN USE CASE
    BrowserRegistrationRequestHandler.onRegistrationCanceled()
    callback(Result.success(Unit))
  }
}
