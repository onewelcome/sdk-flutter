package com.onegini.mobile.sdk.flutter

import android.content.Context
import android.net.Uri
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OnMethodCallMapper(var context: Context) {

    fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_START_APP -> startApp(result)
            Constants.METHOD_REGISTRATION -> RegistrationHelper.registerUser(context,null, arrayOf(call.argument<String>("scopes") ?: ""),result)
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> RegistrationHelper.getIdentityProviders(context,result)
            Constants.METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER -> RegistrationHelper.registrationWithIdentityProvider(context,call.argument<String>("identityProviderId"),call.argument<String>("scopes"),result)
            Constants.METHOD_CANCEL_REGISTRATION -> RegistrationHelper.cancelRegistration()
            Constants.METHOD_DEREGISTER_USER -> RegistrationHelper.deregisterUser(context,result)
            Constants.METHOD_CANCEL_PIN_AUTH -> cancelPinAuth(call.argument<Boolean>("isPin"))
            Constants.METHOD_PIN_AUTHENTICATION -> AuthHelper.authenticateUser(context,OneginiSDK.getOneginiClient(context).userClient.userProfiles.first(),null,result)
            Constants.METHOD_GET_REGISTERED_AUTHENTICATORS -> AuthHelper.getRegisteredAuthenticators(context,result)
            Constants.METHOD_AUTHENTICATE_WITH_REGISTERED_AUTHENTICATION -> AuthHelper.authenticateWithRegisteredAuthenticators(context,call.argument<String>("registeredAuthenticatorsId"),result)
            Constants.METHOD_IS_USER_NOT_REGISTERED_FINGERPRINT -> FingerprintHelper.isUserNotRegisteredFingerprint(context,result)
            Constants.METHOD_REGISTER_FINGERPRINT_AUTHENTICATOR -> FingerprintHelper.registerFingerprint(context, result)
            Constants.METHOD_FINGERPRINT_ACTIVATION_SENSOR ->  FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
            Constants.METHOD_SEND_PIN -> PinHelper.sendPin( call.argument<String>("pin"),call.argument<Boolean>("isAuth"))
            Constants.METHOD_CHANGE_PIN -> PinHelper.startChangePinFlow(context, result)
            Constants.METHOD_OTP_QR_CODE_RESPONSE -> QrCodeHelper.mobileAuthWithOtp(context,call.argument<String>("data"),result)
            Constants.METHOD_ACCEPT_OTP_AUTH -> MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_OTP_AUTH -> MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_SINGLE_SIGN_ON -> startSingleSignOn(call.argument<String>("url"),result)
            Constants.METHOD_LOG_OUT -> logOut(result)

            else -> result.error(ErrorHelper().methodToCallNotFound.code, ErrorHelper().methodToCallNotFound.message, null)
        }
    }

    private fun cancelPinAuth(isPin:Boolean?) {
        if (isPin != null && isPin) {
            PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()
        } else {
            FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
        }
    }

    private fun startApp(result: MethodChannel.Result) {
        val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(context)
        oneginiClient.start(object : OneginiInitializationHandler {
            override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                result.success(Gson().toJson(removedUserProfiles))
            }

            override fun onError(error: OneginiInitializationError?) {
                result.error(error?.errorType.toString(), error?.message, error?.errorDetails)
            }
        })
    }

    //"https://login-mobile.test.onegini.com/personal/dashboard"
    private fun startSingleSignOn(url: String?, result: MethodChannel.Result) {
        val targetUri: Uri = Uri.parse(url)
        OneginiSDK.getOneginiClient(context).userClient.getAppToWebSingleSignOn(targetUri, object : OneginiAppToWebSingleSignOnHandler {
            override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                result.success(Gson().toJson(mapOf("token" to oneginiAppToWebSingleSignOn.token, "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl)))
            }

            override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                result.error(oneginiSingleSignOnError.errorType.toString(), oneginiSingleSignOnError.message, Gson().toJson(oneginiSingleSignOnError.errorDetails))
            }

        })
    }

    private fun logOut(result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context).userClient.logout(object : OneginiLogoutHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiLogoutError?) {
                result.error(error?.errorType.toString(), error?.message, error?.errorDetails)
            }
        })
    }



}