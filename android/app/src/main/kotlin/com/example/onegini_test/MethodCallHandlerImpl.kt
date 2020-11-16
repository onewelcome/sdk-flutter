package com.example.onegini_test

import android.content.Context
import android.util.Log
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MethodCallHandlerImpl(context: Context) : MethodChannel.MethodCallHandler{
    private val context: Context = context
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "startApp") {
            Log.d("Start_app", "START APP")
            val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(context)!!
            oneginiClient.start(object : OneginiInitializationHandler {
                override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                    result.success(true)
                }

                override fun onError(error: OneginiInitializationError?) {
                    Log.d("Start_app", error?.message!!)
                    print(error)
                }
            })
        }
        if (call.method == "getResource") {
            authenticateDevice(context, result)
        }
        if (call.method == "registration") {
            registerUser(null,result)
        }
    }


    private fun authenticateDevice(context: Context, result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(context)?.deviceClient?.authenticateDevice(arrayOf("application-details"), object : OneginiDeviceAuthenticationHandler {
            override fun onSuccess() {
                AnonymousService(context).applicationDetails
                        .subscribe { device -> result.success(Gson().toJson(device)) }
            }

            override fun onError(error: OneginiDeviceAuthenticationError) {

            }
        }
        )
    }

    /**
     * Start registration / LogIn flow
     * when [RegistrationRequestHandler] handled callback, check method [startPinCreation] in [CreatePinRequestHandler]
     */
    private fun registerUser(identityProviderId: String?, result: MethodChannel.Result) {
        //todo this identityProviderId can be use later
        RegistrationHelper.registerUser(context, null, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile?, customInfo: CustomInfo?) {
                if(userProfile!=null)
                    result.success(userProfile.profileId)
            }
            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                val errorType = oneginiRegistrationError.errorType
                var errorMessage: String? = RegistrationHelper.getErrorMessageByCode(errorType)
                if (errorMessage == null) {
                    errorMessage = oneginiRegistrationError.message
                }
                result.error(errorType.toString(),errorMessage ?: "",null)
            }
        })
    }

}