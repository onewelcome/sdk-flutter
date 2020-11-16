package com.example.onegini_test

import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
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
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel




class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.onegini/sdk"

    
    /** 
     * OnNewIntent method for get deeplink from web
     * **/
      
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if(intent.data!=null)
        RegistrationHelper.handleRegistrationCallback(intent.data)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startApp") {
                Log.d("Start_app", "START APP")
                val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(this)!!
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
                authenticateDevice(this, result)
            }
            if (call.method == "registration") {
                registerUser(null,result)
            }
        }
    }


    private fun authenticateDevice(mainActivity: MainActivity, result: MethodChannel.Result) {
        OneginiSDK.getOneginiClient(this)?.deviceClient?.authenticateDevice(arrayOf("application-details"), object : OneginiDeviceAuthenticationHandler {
            override fun onSuccess() {
                AnonymousService(mainActivity).applicationDetails
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
        RegistrationHelper.registerUser(this, null, object : OneginiRegistrationHandler {
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
