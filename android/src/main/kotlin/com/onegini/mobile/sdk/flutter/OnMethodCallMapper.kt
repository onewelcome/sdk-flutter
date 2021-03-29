package com.onegini.mobile.sdk.flutter

import android.content.Context
import android.net.Uri
import android.util.Patterns
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiLogoutHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiLogoutError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.*
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepIdentityProvider
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationAction
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OnMethodCallMapper(var context: Context) {

    fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            Constants.METHOD_START_APP -> startApp(call.argument<String>("twoStepCustomIdentityProviderIds"), call.argument<Int>("connectionTimeout"), call.argument<Int>("readTimeout"), result)
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_SUCCESS -> CustomTwoStepRegistrationAction.CALLBACK?.returnSuccess(call.argument("data"))
            Constants.METHOD_CUSTOM_TWO_STEP_REGISTRATION_RETURN_ERROR -> CustomTwoStepRegistrationAction.CALLBACK?.returnError(Exception(call.argument<String>("error")))


            //Register
            Constants.METHOD_REGISTER_USER -> RegistrationHelper.registerUser(context, call.argument<String>("identityProviderId"), call.argument<String>("scopes"), result)
            Constants.METHOD_GET_IDENTITY_PROVIDERS -> RegistrationHelper.getIdentityProviders(context, result)
            Constants.METHOD_CANCEL_REGISTRATION -> RegistrationHelper.cancelRegistration()
            Constants.METHOD_ACCEPT_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_REGISTRATION_REQUEST -> PinRequestHandler.CALLBACK?.denyAuthenticationRequest()
            Constants.METHOD_DEREGISTER_USER -> RegistrationHelper.deregisterUser(context, result)

            //Authenticate
            Constants.METHOD_AUTHENTICATE_USER -> AuthenticationObject.authenticateUser(context, call.argument<String>("registeredAuthenticatorId"), result)
            Constants.METHOD_GET_REGISTERED_AUTHENTICATORS -> AuthenticationObject.getRegisteredAuthenticators(context, result)
            Constants.METHOD_GET_ALL_NOT_REGISTERED_AUTHENTICATORS -> AuthenticationObject.getNotRegisteredAuthenticators(context, result)
            Constants.METHOD_REGISTER_AUTHENTICATOR -> AuthenticationObject.registerAuthenticator(context, call.argument<String>("authenticatorId"), result)
            Constants.METHOD_LOGOUT -> logout(result)
            Constants.METHOD_ACCEPT_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(call.argument<String>("pin")?.toCharArray())
            Constants.METHOD_DENY_PIN_AUTHENTICATION_REQUEST -> PinAuthenticationRequestHandler.CALLBACK?.denyAuthenticationRequest()

            //Fingerprint
            Constants.METHOD_ACCEPT_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_FINGERPRINT_AUTHENTICATION_REQUEST -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.denyAuthenticationRequest()
            Constants.METHOD_FINGERPRINT_FALL_BACK_TO_PIN -> FingerprintAuthenticationRequestHandler.fingerprintCallback?.fallbackToPin()

            //OTP
            Constants.METHOD_HANDLE_MOBILE_AUTH_WITH_OTP -> MobileAuthenticationObject.mobileAuthWithOtp(context, call.argument<String>("data"), result)
            Constants.METHOD_ACCEPT_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.acceptAuthenticationRequest()
            Constants.METHOD_DENY_OTP_AUTHENTICATION_REQUEST -> MobileAuthOtpRequestHandler.CALLBACK?.denyAuthenticationRequest()

            //Resources
            Constants.METHOD_GET_RESOURCE_ANONYMOUS -> ResourceHelper(context, call, result).getAnonymous()
            Constants.METHOD_GET_RESOURCE -> ResourceHelper(context, call, result).getUserClient()
            Constants.METHOD_GET_IMPLICIT_RESOURCE -> ResourceHelper(context, call, result).getImplicit()

            //Other
            Constants.METHOD_CHANGE_PIN -> startChangePinFlow(context, result)
            Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON -> getAppToWebSingleSignOn(call.argument<String>("url"), result)

            else -> result.error(OneginiWrapperErrors().methodToCallNotFound.code, OneginiWrapperErrors().methodToCallNotFound.message, null)
        }
    }


    private fun startApp(twoStepCustomIdentityProviderIds: String?, connectionTimeout: Int?, readTimeout: Int?, result: MethodChannel.Result) {

        val oneginiCustomIdentityProviderList = mutableListOf<OneginiCustomIdentityProvider>()
        val identityProviderIds = twoStepCustomIdentityProviderIds?.split(",")?.map { it.trim() }
        identityProviderIds?.forEach { oneginiCustomIdentityProviderList.add(CustomTwoStepIdentityProvider(it)) }
        OneginiSDK().initSDK(context,connectionTimeout?.toLong(),readTimeout?.toLong(),oneginiCustomIdentityProviderList)
        val oneginiClient: OneginiClient = OneginiSDK().getOneginiClient(context)
        oneginiClient.start(object : OneginiInitializationHandler {
            override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                val removedUserProfileArray: ArrayList<Map<String, Any>> = ArrayList()
                if(removedUserProfiles!=null){
                    for (userProfile in removedUserProfiles) {
                        val map = mutableMapOf<String, Any>()
                        map["isDefault"] = userProfile?.isDefault ?: false
                        map["profileId"] = userProfile?.profileId ?: ""
                        removedUserProfileArray.add(map)
                    }
                }
                result.success(Gson().toJson(removedUserProfileArray))
            }

            override fun onError(error: OneginiInitializationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }

    //"https://login-mobile.test.onegini.com/personal/dashboard"
    private fun getAppToWebSingleSignOn(url: String?, result: MethodChannel.Result) {
        if (url == null) {
            result.error(OneginiWrapperErrors().urlCantBeNull.code, OneginiWrapperErrors().urlCantBeNull.message, null)
            return
        }
        if (!Patterns.WEB_URL.matcher(url).matches()) {
            result.error(OneginiWrapperErrors().urlIsNotWebPath.code, OneginiWrapperErrors().urlIsNotWebPath.message, null)
            return
        }
        val targetUri: Uri = Uri.parse(url)
        OneginiSDK.getOneginiClient(context).userClient.getAppToWebSingleSignOn(targetUri, object : OneginiAppToWebSingleSignOnHandler {
            override fun onSuccess(oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn) {
                result.success(Gson().toJson(mapOf("token" to oneginiAppToWebSingleSignOn.token, "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl)))
            }

            override fun onError(oneginiSingleSignOnError: OneginiAppToWebSingleSignOnError) {
                result.error(oneginiSingleSignOnError.errorType.toString(), oneginiSingleSignOnError.message, null)
            }

        })
    }

    private fun logout(result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context).userClient.logout(object : OneginiLogoutHandler {
            override fun onSuccess() {
                result.success(true)
            }

            override fun onError(error: OneginiLogoutError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        })
    }

    fun startChangePinFlow(context:Context,result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context).userClient.changePin(object : OneginiChangePinHandler {
            override fun onSuccess() {
                result.success("Pin change successfully")
            }

            override fun onError(error: OneginiChangePinError) {
                result.error(error.errorType.toString(), error.message, "")
            }

        })
    }

}