package com.onegini.mobile.sdk.flutter

import android.content.Context
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OnMethodCallMapper(private var context: Context, private val oneginiMethodsWrapper: OneginiMethodsWrapper, private val oneginiSDK: OneginiSDK) : MethodChannel.MethodCallHandler {


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val client = oneginiSDK.getOneginiClient()
        if (call.method == Constants.METHOD_START_APP) {
            oneginiMethodsWrapper.startApp(call, result, oneginiSDK, context)
        } else if (client != null) {
            onSDKMethodCall(call, client, result)
        } else {
            result.error(OneginiWrapperErrors.ONEGINI_SDK_NOT_INITIALIZED.code, OneginiWrapperErrors.ONEGINI_SDK_NOT_INITIALIZED.message, null)
        }
    }

   private fun onSDKMethodCall(call: MethodCall, client: OneginiClient, result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_SUCCESS -> CustomTwoStepRegistrationAction.CALLBACK?.returnSuccess(call.argument("data"))
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_ERROR -> CustomTwoStepRegistrationAction.CALLBACK?.returnError(Exception(call.argument<String>("error")))

            //Register
            Constants.METHOD_REGISTER_USER -> oneginiMethodsWrapper.registerUser(call, result, client)
            Constants.METHOD_HANDLE_REGISTERED_URL -> oneginiMethodsWrapper.handleRegisteredUrl(call, context, client)
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> oneginiMethodsWrapper.getIdentityProviders(result, client)
            Constants.METHOD_CANCEL_REGISTRATION -> oneginiMethodsWrapper.cancelRegistration()
            Constants.METHOD_ACCEPT_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_DEREGISTER_USER -> oneginiMethodsWrapper.deregisterUser(call, result, client)

            // Authenticate
            Constants.METHOD_REGISTER_AUTHENTICATOR -> oneginiMethodsWrapper.registerAuthenticator(call, result, client)
            Constants.METHOD_GET_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getRegisteredAuthenticators(result, client)
            Constants.METHOD_AUTHENTICATE_USER -> oneginiMethodsWrapper.authenticateUser(call, result, client)
            Constants.METHOD_GET_ALL_AUTHENTICATORS -> oneginiMethodsWrapper.getAllAuthenticators(result, client)
            Constants.METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getNotRegisteredAuthenticators(result, client)
            Constants.METHOD_SET_PREFERRED_AUTHENTICATOR -> oneginiMethodsWrapper.setPreferredAuthenticator(call, result, client)
            Constants.METHOD_DEREGISTER_AUTHENTICATOR -> oneginiMethodsWrapper.deregisterAuthenticator(call, result, client)
            Constants.METHOD_LOGOUT -> oneginiMethodsWrapper.logout(result, client)
            Constants.METHOD_ACCEPT_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_IS_AUTHENTICATOR_REGISTERED -> oneginiMethodsWrapper.isAuthenticatorRegistered(call, result, client)

            // Fingerprint
            Constants.METHOD_ACCEPT_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
            Constants.METHOD_FINGERPRINT_FALL_BACK_TO_PIN -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.fallbackToPin()

            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, client)
            Constants.METHOD_ACCEPT_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()

            // Resources
            Constants.METHOD_AUTHENTICATE_USER_IMPLICITLY -> oneginiMethodsWrapper.authenticateUserImplicitly(call, result, client)
            Constants.METHOD_AUTHENTICATE_DEVICE -> oneginiMethodsWrapper.authenticateDevice(call, result, client)
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> oneginiMethodsWrapper.getResourceAnonymous(call, result, client, ResourceHelper())
            Constants.METHOD_GET_RESOURCE -> oneginiMethodsWrapper.getResource(call, result, client, ResourceHelper())
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> oneginiMethodsWrapper.getImplicitResource(call, result, client, ResourceHelper())
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> oneginiMethodsWrapper.getUnauthenticatedResource(call, result, client, ResourceHelper())

            // Other
            Constants.METHOD_CHANGE_PIN -> oneginiMethodsWrapper.changePin(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> oneginiMethodsWrapper.getAppToWebSingleSignOn(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_REDIRECT_URL -> oneginiMethodsWrapper.getRedirectUrl(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_USER_PROFILES -> oneginiMethodsWrapper.getUserProfiles(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_ACCESS_TOKEN -> oneginiMethodsWrapper.getAccessToken(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_AUTHENTICATED_USER_PROFILE -> oneginiMethodsWrapper.getAuthenticatedUserProfile(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_CHANGE_PIN -> startChangePinFlow(result, client)
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> getAppToWebSingleSignOn(call.argument<String>("url"), result, client)
            Constants.METHOD_GET_USER_PROFILES -> oneginiMethodsWrapper.getUserProfiles(result, client)
            Constants.METHOD_GET_ACCESS_TOKEN -> oneginiMethodsWrapper.getAccessToken(result, client)
            Constants.METHOD_GET_AUTHENTICATED_USER_PROFILE -> oneginiMethodsWrapper.getAuthenticatedUserProfile(result, client)
            Constants.METHOD_GET_REDIRECT_URL -> oneginiMethodsWrapper.getRedirectUrl(result, client)

            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> oneginiMethodsWrapper.validatePinWithPolicy(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> validatePinWithPolicy(call.argument<String>("pin")?.toCharArray(), result, client)

            else -> result.error(OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.code, OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.message, null)
        }
    }
}
