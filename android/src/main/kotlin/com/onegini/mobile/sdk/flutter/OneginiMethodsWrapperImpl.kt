package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class OneginiMethodsWrapperImpl(private val registrationUseCase: RegistrationUseCase = RegistrationUseCase()) : IOneginiMethodsWrapper {

    override fun registerUser(call: MethodCall,result: MethodChannel.Result,oneginiClient: OneginiClient){
        registrationUseCase(call,oneginiClient,result)
    }


}