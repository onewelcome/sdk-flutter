package com.onegini.plugin.onegini_example

import android.content.Context
import android.util.Log
import android.widget.Toast
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.plugin.onegini.OneginiSDK


class TwoWayOtpRegistrationAction(private val context: Context) : OneginiCustomTwoStepRegistrationAction {
    override fun initRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        callback.returnSuccess(null)
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo) {
        CALLBACK = callback
        if(customInfo.status <2001){
            OneginiSDK.getOneginiClient(context)?.userClient?.userProfiles?.map { Log.v("id", it.profileId) }
            EventStorage.events?.success(Gson().toJson(Events("OPEN_OTP",customInfo.data)))
        }else {
            Toast.makeText(context,"Error. Status code => ${customInfo.status}",Toast.LENGTH_SHORT).show()
        }

    }

    companion object {
        var CALLBACK: OneginiCustomRegistrationCallback? = null
    }

}