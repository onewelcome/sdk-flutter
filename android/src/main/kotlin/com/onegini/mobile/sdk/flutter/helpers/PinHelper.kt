package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.OneginiChangePinHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiChangePinError
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import io.flutter.plugin.common.MethodChannel

object PinHelper {

    fun sendPin(pin: String?,auth: Boolean?){
        if (auth != null && auth) {
            PinAuthenticationRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin?.toCharArray())
        } else {
            PinRequestHandler.CALLBACK?.acceptAuthenticationRequest(pin?.toCharArray())
        }
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