package com.onegini.mobile.sdk.flutter

import android.net.Uri
import android.util.Patterns
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
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import javax.inject.Inject

class OnMethodCallMapper @Inject constructor(private val oneginiMethodsWrapper: OneginiMethodsWrapper, private val oneginiSDK: OneginiSDK) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                Constants.METHOD_START_APP -> oneginiMethodsWrapper.startApp(call, result)
                else -> onSDKMethodCall(call, oneginiSDK.oneginiClient, result)
            }
        } catch (err: FlutterPluginException) {
            SdkError(ONEWELCOME_SDK_NOT_INITIALIZED).flutterError(result)
        }
    }

    private fun onSDKMethodCall(call: MethodCall, client: OneginiClient, result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_IS_AUTHENTICATOR_REGISTERED -> oneginiMethodsWrapper.isAuthenticatorRegistered(call, result)

            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, client)

            // Resources
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> oneginiMethodsWrapper.getResourceAnonymous(call, result)
            Constants.METHOD_GET_RESOURCE -> oneginiMethodsWrapper.getResource(call, result)
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> oneginiMethodsWrapper.getImplicitResource(call, result)
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> oneginiMethodsWrapper.getUnauthenticatedResource(call, result)

            // Other
            Constants.METHOD_CHANGE_PIN -> startChangePinFlow(result, client)
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> getAppToWebSingleSignOn(call.argument<String>("url"), result, client)

            Constants.METHOD_VALIDATE_PIN_WITH_POLICY -> validatePinWithPolicy(call.argument<String>("pin")?.toCharArray(), result, client)

            else -> SdkError(METHOD_TO_CALL_NOT_FOUND).flutterError(result)
        }
    }

    private fun validatePinWithPolicy(pin: CharArray?, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        val nonNullPin = pin ?: return SdkError(ARGUMENT_NOT_CORRECT.code, ARGUMENT_NOT_CORRECT.message + " pin is null").flutterError(result)

        oneginiClient.userClient.validatePinWithPolicy(
            nonNullPin,
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
