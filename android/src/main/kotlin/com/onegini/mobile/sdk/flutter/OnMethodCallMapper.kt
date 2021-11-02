package com.onegini.mobile.sdk.flutter

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Patterns
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
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
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class OnMethodCallMapper(private var context: Context, private val oneginiMethodsWrapper: OneginiMethodsWrapper, private val oneginiSDK: OneginiSDK, private val oneginiEventSender: OneginiEventsSender) : MethodChannel.MethodCallHandler{

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_START_APP -> oneginiMethodsWrapper.startApp(call, oneginiSDK, result, oneginiEventSender, context)
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_SUCCESS -> CustomTwoStepRegistrationAction.CALLBACK?.returnSuccess(call.argument("data"))
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_ERROR -> CustomTwoStepRegistrationAction.CALLBACK?.returnError(Exception(call.argument<String>("error")))

            // Register
            Constants.METHOD_REGISTER_USER -> oneginiMethodsWrapper.registerUser(call, result, oneginiSDK.getOneginiClient())
            Constants.METHOD_HANDLE_REGISTERED_URL -> oneginiMethodsWrapper.handleRegisteredUrl(call, context, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> oneginiMethodsWrapper.getIdentityProviders(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_CANCEL_REGISTRATION -> oneginiMethodsWrapper.cancelRegistration(oneginiSDK.getRegistrationRequestHandler(),RegistrationRequestHandler.CALLBACK)
            Constants.METHOD_ACCEPT_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_DEREGISTER_USER -> oneginiMethodsWrapper.deregisterUser(call, result, oneginiSDK.getOneginiClient())

            // Authenticate
            Constants.METHOD_REGISTER_AUTHENTICATOR -> oneginiMethodsWrapper.registerAuthenticator(call, result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getRegisteredAuthenticators(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_AUTHENTICATE_USER -> oneginiMethodsWrapper.authenticateUser(call, result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_ALL_AUTHENTICATORS -> oneginiMethodsWrapper.getAllAuthenticators(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS -> oneginiMethodsWrapper.getNotRegisteredAuthenticators(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_SET_PREFERRED_AUTHENTICATOR -> oneginiMethodsWrapper.setPreferredAuthenticator(call, result, oneginiSDK.getOneginiClient())
            Constants.METHOD_DEREGISTER_AUTHENTICATOR -> oneginiMethodsWrapper.deregisterAuthenticator(call, result, oneginiSDK.getOneginiClient())
            Constants.METHOD_LOGOUT -> logout(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_ACCEPT_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()

            // Fingerprint
            Constants.METHOD_ACCEPT_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
            Constants.METHOD_FINGERPRINT_FALL_BACK_TO_PIN -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.fallbackToPin()

            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, oneginiSDK.getOneginiClient())
            Constants.METHOD_ACCEPT_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()

            // Resources
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> ResourceHelper(call, result, oneginiSDK.getOneginiClient()).getAnonymous()
            Constants.METHOD_GET_RESOURCE -> ResourceHelper(call, result, oneginiSDK.getOneginiClient()).getUserClient()
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> ResourceHelper(call, result, oneginiSDK.getOneginiClient()).getImplicit()
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> ResourceHelper(call, result, oneginiSDK.getOneginiClient()).getUnauthenticatedResource()

            // Other
            Constants.METHOD_CHANGE_PIN -> startChangePinFlow(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> getAppToWebSingleSignOn(call.argument<String>("url"), result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_USER_PROFILES -> oneginiMethodsWrapper.getUserProfiles(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_ACCESS_TOKEN -> oneginiMethodsWrapper.getAccessToken(result, oneginiSDK.getOneginiClient())
            Constants.METHOD_GET_AUTHENTICATED_USER_PROFILE -> oneginiMethodsWrapper.getAuthenticatedUserProfile(result, oneginiSDK.getOneginiClient())

            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> validatePinWithPolicy(call.argument<String>("pin")?.toCharArray(), result, oneginiSDK.getOneginiClient())

            else -> result.error(OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.code, OneginiWrapperErrors.METHOD_TO_CALL_NOT_FOUND.message, null)
        }
    }

    // "https://login-mobile.test.onegini.com/personal/dashboard"
    fun getAppToWebSingleSignOn(url: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (url == null) {
            result.error(OneginiWrapperErrors.URL_CANT_BE_NULL.code, OneginiWrapperErrors.URL_CANT_BE_NULL.message, null)
            return
        }
        if (!Patterns.WEB_URL.matcher(url).matches()) {
            result.error(OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.code, OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.message, null)
            return
        }
        val targetUri: Uri = Uri.parse(url)
        oneginiClient.userClient.getAppToWebSingleSignOn(
            targetUri,
            object : OneginiAppToWebSingleSignOnHandler {
                override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                    result.success(Gson().toJson(mapOf("token" to oneginiAppToWebSingleSignOn.token, "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl.toString())))
                }

                override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                    result.error(oneginiSingleSignOnError.errorType.toString(), oneginiSingleSignOnError.message, null)
                }
            }
        )
    }

    private fun validatePinWithPolicy(pin: CharArray?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.validatePinWithPolicy(
            pin,
            object : OneginiPinValidationHandler {
                override fun onSuccess() {
                    result.success(true)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    result.error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message, null)
                }
            }
        )
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

    fun startChangePinFlow(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.changePin(object : OneginiChangePinHandler {
            override fun onSuccess() {
                result.success("Pin change successfully")
            }

            override fun onError(error: OneginiChangePinError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }
}
