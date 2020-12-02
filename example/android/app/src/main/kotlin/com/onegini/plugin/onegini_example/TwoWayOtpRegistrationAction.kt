package com.onegini.plugin.onegini_example

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiCustomRegistrationCallback
import com.onegini.mobile.sdk.android.model.entity.CustomInfo


class TwoWayOtpRegistrationAction(private val context: Context) : OneginiCustomTwoStepRegistrationAction {
    override fun initRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo?) {
        callback.returnSuccess(null)
    }

    override fun finishRegistration(callback: OneginiCustomRegistrationCallback, customInfo: CustomInfo) {
        CALLBACK = callback
        val str = customInfo.data
        if(customInfo.status <4000)
        CALLBACK!!.returnSuccess(str)
        else CALLBACK!!.returnError(Exception("Something went wrong"))
    }

    companion object {
        var CALLBACK: OneginiCustomRegistrationCallback? = null
    }

}