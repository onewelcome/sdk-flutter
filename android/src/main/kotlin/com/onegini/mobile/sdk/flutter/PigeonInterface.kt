package com.onegini.mobile.sdk.flutter

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

  // Example function on how it could be initiated on Flutter send to Native
  override fun fetchUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
    val a = Result.success(listOf(OWUserProfile("ghalo")))
    flutterCallback(callback, a)

//    val b = Result.failure<List<OneWelcomeUserProfile>>(SdkError(2000, "hallo"))
//    flutterCallback(callback, b)
  }

  override fun registerUser(identityProviderId: String?, scopes: List<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    registrationUseCase(identityProviderId, scopes, callback)
//    flutterCallback(callback, result)
  }

  override fun handleRegisteredUserUrl(url: String?, signInType: Long, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getIdentityProviders(callback: (Result<List<OWIdentityProvider>>) -> Unit) {
    val result = getIdentityProvidersUseCase()
    flutterCallback(callback, result)
  }

  override fun deregisterUser(profileId: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAllAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAuthenticatedUserProfile(callback: (Result<OWUserProfile>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun authenticateUser(profileId: String, registeredAuthenticatorId: String?, callback: (Result<OWRegistrationResponse>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getNotRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun changePin(callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun setPreferredAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun deregisterAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun registerAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun logout(callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun mobileAuthWithOtp(data: String, callback: (Result<String?>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAppToWebSingleSignOn(url: String, callback: (Result<OWAppToWebSingleSignOn>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getAccessToken(callback: (Result<String>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getRedirectUrl(callback: (Result<String>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun getUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun validatePinWithPolicy(pin: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun authenticateDevice(scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun authenticateUserImplicitly(profileId: String, scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun submitCustomRegistrationAction(identityProviderId: String, data: String?, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  override fun cancelCustomRegistrationAction(identityProviderId: String, error: String, callback: (Result<Unit>) -> Unit) {
//    TODO("Not yet implemented")
  }

  private fun <T> flutterCallback(callback: (Result<T>)  -> Unit, result: Result<T>) {
    result.fold(
      onFailure = { error ->
        when (error) {
          is SdkError -> callback(Result.failure(error.pigeonError()))
          else -> callback(Result.failure(error))
        }
      },
      onSuccess = { value ->
        callback(Result.success(value))
      }
    )
  }
}