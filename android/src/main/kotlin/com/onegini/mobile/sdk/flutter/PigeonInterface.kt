package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile

open class PigeonInterface: UserClientApi {
  // Example function on how it could be initiated on Flutter send to Native
  override fun fetchUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
    val a = Result.success(listOf(OWUserProfile("ghalo")))
    flutterCallback(callback, a)

//    val b = Result.failure<List<OneWelcomeUserProfile>>(SdkError(2000, "hallo"))
//    flutterCallback(callback, b)
  }

  override fun registerUser(identityProviderId: String?, scopes: List<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun handleRegisteredUserUrl(url: String?, signInType: Long, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getIdentityProviders(callback: (Result<List<OWIdentityProvider>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun deregisterUser(profileId: String, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getAllAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getAuthenticatedUserProfile(callback: (Result<OWUserProfile>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun authenticateUser(profileId: String, registeredAuthenticatorId: String?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getNotRegisteredAuthenticators(profileId: String, callback: (Result<List<OWAuthenticator>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun changePin(callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun setPreferredAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun deregisterAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun registerAuthenticator(authenticatorId: String, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun logout(callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun mobileAuthWithOtp(data: String, callback: (Result<String?>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getAppToWebSingleSignOn(url: String, callback: (Result<OWAppToWebSingleSignOn>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getAccessToken(callback: (Result<String>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getRedirectUrl(callback: (Result<String>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun getUserProfiles(callback: (Result<List<OWUserProfile>>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun validatePinWithPolicy(pin: String, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun authenticateDevice(scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun authenticateUserImplicitly(profileId: String, scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
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