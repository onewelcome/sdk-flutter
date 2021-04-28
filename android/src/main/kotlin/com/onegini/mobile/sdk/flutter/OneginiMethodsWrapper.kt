package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.useCases.HandleRegisteredUrlUseCase
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapper {

    fun registerUser(call: MethodCall, result: MethodChannel.Result, oneginiClient: OneginiClient) {
        RegistrationUseCase(oneginiClient)(call, result)
    }

    fun handleRegisteredUrl(call: MethodCall, context: Context) {
        HandleRegisteredUrlUseCase()(call, context)
    }

    fun startApp(call: MethodCall,result: MethodChannel.Result,context: Context){
        StartAppUseCase()(call,result,context,OneginiSDK())
    }
}