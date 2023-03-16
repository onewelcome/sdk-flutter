package com.onegini.mobile.sdk.flutter

import android.net.Uri
import android.util.Patterns
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.constants.Constants
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
            // TODO: Move remaining methods to pigeon; https://onewelcome.atlassian.net/browse/FP-71
            Constants.METHOD_IS_AUTHENTICATOR_REGISTERED -> oneginiMethodsWrapper.isAuthenticatorRegistered(call, result)

            // OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(call.argument<String>("data"), result, client)

            // Resources
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> oneginiMethodsWrapper.getResourceAnonymous(call, result)
            Constants.METHOD_GET_RESOURCE -> oneginiMethodsWrapper.getResource(call, result)
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> oneginiMethodsWrapper.getImplicitResource(call, result)
            Constants.METHOD_GET_UNAUTHENTICATED_RESOURCE -> oneginiMethodsWrapper.getUnauthenticatedResource(call, result)

            else -> SdkError(METHOD_TO_CALL_NOT_FOUND).flutterError(result)
        }
    }
}
