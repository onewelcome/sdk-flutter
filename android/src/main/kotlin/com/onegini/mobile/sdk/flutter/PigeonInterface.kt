package com.onegini.mobile.sdk.flutter

import android.net.Uri
import android.util.Patterns
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestDetails
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceMethodApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceRequestType
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateDeviceUseCase
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserImplicitlyUseCase
import com.onegini.mobile.sdk.flutter.useCases.AuthenticateUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.CancelBrowserRegistrationUseCase
import com.onegini.mobile.sdk.flutter.useCases.CancelCustomRegistrationActionUseCase
import com.onegini.mobile.sdk.flutter.useCases.ChangePinUseCase
import com.onegini.mobile.sdk.flutter.useCases.DeregisterAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.DeregisterUserUseCase
import com.onegini.mobile.sdk.flutter.useCases.EnrollMobileAuthenticationUseCase
import com.onegini.mobile.sdk.flutter.useCases.FingerprintAuthenticationRequestAcceptUseCase
import com.onegini.mobile.sdk.flutter.useCases.FingerprintAuthenticationRequestDenyUseCase
import com.onegini.mobile.sdk.flutter.useCases.FingerprintFallbackToPinUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAccessTokenUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetAuthenticatedUserProfileUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetIdentityProvidersUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetNotRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetRedirectUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfilesUseCase
import com.onegini.mobile.sdk.flutter.useCases.HandleMobileAuthWithOtpUseCase
import com.onegini.mobile.sdk.flutter.useCases.HandleRegisteredUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.LogoutUseCase
import com.onegini.mobile.sdk.flutter.useCases.OtpAcceptAuthenticationRequestUseCase
import com.onegini.mobile.sdk.flutter.useCases.OtpDenyAuthenticationRequestUseCase
import com.onegini.mobile.sdk.flutter.useCases.PinAuthenticationRequestAcceptUseCase
import com.onegini.mobile.sdk.flutter.useCases.PinAuthenticationRequestDenyUseCase
import com.onegini.mobile.sdk.flutter.useCases.PinRegistrationRequestAcceptUseCase
import com.onegini.mobile.sdk.flutter.useCases.PinRegistrationRequestDenyUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegisterAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import com.onegini.mobile.sdk.flutter.useCases.ResourceRequestUseCase
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import com.onegini.mobile.sdk.flutter.useCases.SubmitCustomRegistrationActionUseCase
import com.onegini.mobile.sdk.flutter.useCases.ValidatePinWithPolicyUseCase
import javax.inject.Inject

open class PigeonInterface : UserClientApi, ResourceMethodApi {
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
  lateinit var cancelBrowserRegistrationUseCase: CancelBrowserRegistrationUseCase
  @Inject
  lateinit var getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase
  @Inject
  lateinit var getAuthenticatedUserProfileUseCase: GetAuthenticatedUserProfileUseCase
  @Inject
  lateinit var getIdentityProvidersUseCase: GetIdentityProvidersUseCase
  @Inject
  lateinit var getNotRegisteredAuthenticatorsUseCase: GetNotRegisteredAuthenticatorsUseCase
  @Inject
  lateinit var getRedirectUrlUseCase: GetRedirectUrlUseCase
  @Inject
  lateinit var getRegisteredAuthenticatorsUseCase: GetRegisteredAuthenticatorsUseCase
  @Inject
  lateinit var getUserProfilesUseCase: GetUserProfilesUseCase
  @Inject
  lateinit var handleRegisteredUrlUseCase: HandleRegisteredUrlUseCase
  @Inject
  lateinit var logoutUseCase: LogoutUseCase
  @Inject
  lateinit var registerAuthenticatorUseCase: RegisterAuthenticatorUseCase
  @Inject
  lateinit var registrationUseCase: RegistrationUseCase
  @Inject
  lateinit var setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase
  @Inject
  lateinit var startAppUseCase: StartAppUseCase
  @Inject
  lateinit var submitCustomRegistrationActionUseCase: SubmitCustomRegistrationActionUseCase
  @Inject
  lateinit var changePinUseCase: ChangePinUseCase
  @Inject
  lateinit var validatePinWithPolicyUseCase: ValidatePinWithPolicyUseCase
  @Inject
  lateinit var pinAuthenticationRequestAcceptUseCase: PinAuthenticationRequestAcceptUseCase
  @Inject
  lateinit var pinAuthenticationRequestDenyUseCase: PinAuthenticationRequestDenyUseCase
  @Inject
  lateinit var pinRegistrationRequestAcceptUseCase: PinRegistrationRequestAcceptUseCase
  @Inject
  lateinit var pinRegistrationRequestDenyUseCase: PinRegistrationRequestDenyUseCase
  @Inject
  lateinit var fingerprintAuthenticationRequestDenyUseCase: FingerprintAuthenticationRequestDenyUseCase
  @Inject
  lateinit var fingerprintAuthenticationRequestAcceptUseCase: FingerprintAuthenticationRequestAcceptUseCase
  @Inject
  lateinit var fingerprintFallbackToPinUseCase: FingerprintFallbackToPinUseCase
  @Inject
  lateinit var resourceRequestUseCase: ResourceRequestUseCase
  @Inject
  lateinit var enrollMobileAuthenticationUseCase: EnrollMobileAuthenticationUseCase
  @Inject
  lateinit var handleMobileAuthWithOtpUseCase: HandleMobileAuthWithOtpUseCase
  @Inject
  lateinit var otpDenyAuthenticationRequestUseCase: OtpDenyAuthenticationRequestUseCase
  @Inject
  lateinit var otpAcceptAuthenticationRequestUseCase: OtpAcceptAuthenticationRequestUseCase
  @Inject
  lateinit var oneginiSDK: OneginiSDK

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

  override fun enrollMobileAuthentication(callback: (Result<Unit>) -> Unit) {
    enrollMobileAuthenticationUseCase(callback)
  }

  override fun handleMobileAuthWithOtp(data: String, callback: (Result<Unit>) -> Unit) {
    handleMobileAuthWithOtpUseCase(data, callback)
  }


  override fun getAppToWebSingleSignOn(url: String, callback: (Result<OWAppToWebSingleSignOn>) -> Unit) {
    // TODO NEEDS OWN USE CASE; https://onewelcome.atlassian.net/browse/FP-62
    if (!Patterns.WEB_URL.matcher(url).matches()) {
      callback(Result.failure(SdkError(OneWelcomeWrapperErrors.MALFORMED_URL).pigeonError()))
      return
    }
    val targetUri: Uri = Uri.parse(url)

    oneginiSDK.oneginiClient.userClient.getAppToWebSingleSignOn(
      targetUri,
      object : OneginiAppToWebSingleSignOnHandler {
        override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
          callback(Result.success(OWAppToWebSingleSignOn(oneginiAppToWebSingleSignOn.token, oneginiAppToWebSingleSignOn.redirectUrl.toString())))
        }

        override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
          callback(Result.failure(SdkError(
            code = oneginiSingleSignOnError.errorType,
            message = oneginiSingleSignOnError.message
          ).pigeonError()))
        }
      }
    )
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
    validatePinWithPolicyUseCase(pin, callback)
  }

  override fun authenticateDevice(scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    authenticateDeviceUseCase(scopes, callback)
  }

  override fun authenticateUserImplicitly(profileId: String, scopes: List<String>?, callback: (Result<Unit>) -> Unit) {
    authenticateUserImplicitlyUseCase(profileId, scopes, callback)
  }

  // Callback functions
  override fun submitCustomRegistrationAction(identityProviderId: String, data: String?, callback: (Result<Unit>) -> Unit) {
    callback(submitCustomRegistrationActionUseCase(identityProviderId, data))
  }

  override fun cancelCustomRegistrationAction(identityProviderId: String, error: String, callback: (Result<Unit>) -> Unit) {
    callback(cancelCustomRegistrationActionUseCase(identityProviderId, error))
  }

  override fun fingerprintFallbackToPin(callback: (Result<Unit>) -> Unit) {
    callback(fingerprintFallbackToPinUseCase())
  }

  override fun fingerprintDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    callback(fingerprintAuthenticationRequestDenyUseCase())
  }

  override fun fingerprintAcceptAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    callback(fingerprintAuthenticationRequestAcceptUseCase())
  }

  override fun otpDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    callback(otpDenyAuthenticationRequestUseCase())
  }

  override fun otpAcceptAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    callback(otpAcceptAuthenticationRequestUseCase())
  }

  override fun pinDenyAuthenticationRequest(callback: (Result<Unit>) -> Unit) {
    callback(pinAuthenticationRequestDenyUseCase())
  }

  override fun pinAcceptAuthenticationRequest(pin: String, callback: (Result<Unit>) -> Unit) {
    callback(pinAuthenticationRequestAcceptUseCase(pin))
  }

  override fun pinDenyRegistrationRequest(callback: (Result<Unit>) -> Unit) {
    callback(pinRegistrationRequestDenyUseCase())
  }

  override fun pinAcceptRegistrationRequest(pin: String, callback: (Result<Unit>) -> Unit) {
    callback(pinRegistrationRequestAcceptUseCase(pin))
  }

  override fun cancelBrowserRegistration(callback: (Result<Unit>) -> Unit) {
    callback(cancelBrowserRegistrationUseCase())
  }

  override fun requestResource(type: ResourceRequestType, details: OWRequestDetails, callback: (Result<OWRequestResponse>) -> Unit) {
    resourceRequestUseCase(type, details, callback)
  }
}
fun CustomInfo.mapToOwCustomInfo(): OWCustomInfo {
  return OWCustomInfo(this.status.toLong(), this.data)
}
