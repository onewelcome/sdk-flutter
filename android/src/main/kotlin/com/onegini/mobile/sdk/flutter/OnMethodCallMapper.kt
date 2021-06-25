package com.onegini.mobile.sdk.flutter

import android.content.Context
import androidx.annotation.NonNull
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.AuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OnMethodCallMapper(private var context: Context, private val oneginiMethodsWrapper: OneginiMethodsWrapper) : MethodChannel.MethodCallHandler {


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_START_APP -> oneginiMethodsWrapper.startApp(call, result, context)
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_SUCCESS -> CustomTwoStepRegistrationAction.CALLBACK?.returnSuccess(call.argument("data"))
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_ERROR -> CustomTwoStepRegistrationAction.CALLBACK?.returnError(Exception(call.argument<String>("error")))


            //Register
            Constants.METHOD_REGISTER_USER -> oneginiMethodsWrapper.registerUser(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_HANDLE_REGISTERED_URL -> oneginiMethodsWrapper.handleRegisteredUrl(call, context)
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> oneginiMethodsWrapper.getIdentityProviders(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_CANCEL_REGISTRATION -> oneginiMethodsWrapper.cancelRegistration()
            Constants.METHOD_ACCEPT_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_DEREGISTER_USER -> oneginiMethodsWrapper.deregisterUser(result, OneginiSDK().getOneginiClient(context))

            // Authenticate
            Constants.METHOD_GET_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getRegisteredAuthenticators(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_AUTHENTICATE_USER -> oneginiMethodsWrapper.authenticateUser(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_ALL_AUTHENTICATORS -> oneginiMethodsWrapper.getAllAuthenticators(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getNotRegisteredAuthenticators(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_REGISTER_AUTHENTICATOR -> AuthenticationObject.registerAuthenticator(call.argument<String>("authenticatorId"), result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_SET_PREFERRED_AUTHENTICATOR -> oneginiMethodsWrapper.setPreferredAuthenticator(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_DEREGISTER_AUTHENTICATOR -> AuthenticationObject.deregisterAuthenticator(call.argument<String>("authenticatorId"), result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_LOGOUT -> logout(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_ACCEPT_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()

            // Fingerprint
            Constants.METHOD_ACCEPT_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
            Constants.METHOD_FINGERPRINT_FALL_BACK_TO_PIN -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.fallbackToPin()

            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_ACCEPT_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()

            // Resources
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> ResourceHelper(call, result, OneginiSDK().getOneginiClient(context)).getAnonymous()
            Constants.METHOD_GET_RESOURCE -> ResourceHelper(call, result, OneginiSDK().getOneginiClient(context)).getUserClient()
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> ResourceHelper(call, result, OneginiSDK().getOneginiClient(context)).getImplicit()
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> ResourceHelper(call, result, OneginiSDK().getOneginiClient(context)).getUnauthenticatedResource()

            // Other
            Constants.METHOD_CHANGE_PIN -> oneginiMethodsWrapper.changePin(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> oneginiMethodsWrapper.getAppToWebSingleSignOn(call, result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_USER_PROFILES -> oneginiMethodsWrapper.getUserProfiles(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_ACCESS_TOKEN -> oneginiMethodsWrapper.getAccessToken(result, OneginiSDK().getOneginiClient(context))
            Constants.METHOD_GET_AUTHENTICATED_USER_PROFILE -> oneginiMethodsWrapper.getAuthenticatedUserProfile(result, OneginiSDK().getOneginiClient(context))

            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> oneginiMethodsWrapper.validatePinWithPolicy(call, result, OneginiSDK().getOneginiClient(context))

            else -> result.error(OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.code, OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.message, null)
        }
    }

    fun logout(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.logout(object : OneginiLogoutHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiLogoutError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }

}
