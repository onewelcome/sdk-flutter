package com.onegini.mobile.sdk.flutter

import android.content.Context
import android.net.Uri
import android.util.Patterns
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import javax.inject.Inject

class OnMethodCallMapper @Inject constructor(private val oneginiMethodsWrapper: OneginiMethodsWrapper, private val oneginiSDK: OneginiSDK) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when {
                call.method == Constants.METHOD_START_APP -> oneginiMethodsWrapper.startApp(call, result, oneginiSDK)
                else -> onSDKMethodCall(call, oneginiSDK.oneginiClient, result)
            }
        } catch (err: FlutterPluginException) {
            // FIXME: This can be done better with an extension function for MethodChannel.Result.error
            SdkError(ONEWELCOME_SDK_NOT_INITIALIZED).flutterError(result)
        }
    }

    private fun onSDKMethodCall(call: MethodCall, client: OneginiClient, result: MethodChannel.Result) {
        when (call.method) {
            // Custom Registration Callbacks
            Constants.METHOD_SUBMIT_CUSTOM_REGISTRATION_ACTION -> oneginiMethodsWrapper.respondCustomRegistrationAction(call, result)
            Constants.METHOD_CANCEL_CUSTOM_REGISTRATION_ACTION -> oneginiMethodsWrapper.cancelCustomRegistrationAction(call, result)

            //Register
            Constants.METHOD_REGISTER_USER -> oneginiMethodsWrapper.registerUser(call, result)
            Constants.METHOD_HANDLE_REGISTERED_URL -> oneginiMethodsWrapper.handleRegisteredUrl(call, client)
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> oneginiMethodsWrapper.getIdentityProviders(result, client)
            Constants.METHOD_CANCEL_BROWSER_REGISTRATION -> oneginiMethodsWrapper.cancelBrowserRegistration()
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
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> oneginiMethodsWrapper.getResourceAnonymous(call, result, client)
            Constants.METHOD_GET_RESOURCE -> oneginiMethodsWrapper.getResource(call, result, client)
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> oneginiMethodsWrapper.getImplicitResource(call, result, client)
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> oneginiMethodsWrapper.getUnauthenticatedResource(call, result, client)

            // Other
            Constants.METHOD_CHANGE_PIN -> startChangePinFlow(result, client)
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> getAppToWebSingleSignOn(call.argument<String>("url"), result, client)
            Constants.METHOD_GET_USER_PROFILES -> oneginiMethodsWrapper.getUserProfiles(result, client)
            Constants.METHOD_GET_ACCESS_TOKEN -> oneginiMethodsWrapper.getAccessToken(result, client)
            Constants.METHOD_GET_AUTHENTICATED_USER_PROFILE -> oneginiMethodsWrapper.getAuthenticatedUserProfile(result, client)
            Constants.METHOD_GET_REDIRECT_URL -> oneginiMethodsWrapper.getRedirectUrl(result, client)

            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> validatePinWithPolicy(call.argument<String>("pin")?.toCharArray(), result, client)

            else -> SdkError(METHOD_TO_CALL_NOT_FOUND).flutterError(result)
        }
    }

    private fun validatePinWithPolicy(pin: CharArray?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.validatePinWithPolicy(
            pin,
            object : OneginiPinValidationHandler {
                override fun onSuccess() {
                    result.success(true)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    SdkError(
                        code = oneginiPinValidationError.errorType,
                        message = oneginiPinValidationError.message
                    ).flutterError(result)
                }
            }
        )
    }

    fun getAppToWebSingleSignOn(url: String?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        if (url == null) {
            SdkError(URL_CANT_BE_NULL).flutterError(result)
            return
        }
        if (!Patterns.WEB_URL.matcher(url).matches()) {
            SdkError(MALFORMED_URL).flutterError(result)
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
                        SdkError(
                            code = oneginiSingleSignOnError.errorType,
                            message = oneginiSingleSignOnError.message
                        ).flutterError(result)
                    }
                }
        )
    }

    fun startChangePinFlow(result: MethodChannel.Result, oneginiClient: OneginiClient) {
        oneginiClient.userClient.changePin(object : OneginiChangePinHandler {
            override fun onSuccess() {
                result.success("Pin change successfully")
            }

            override fun onError(error: OneginiChangePinError) {
                SdkError(
                    code = error.errorType,
                    message = error.message
                ).flutterError(result)
            }
        })
    }
}
