package com.onegini.mobile.onegini_example.providers

import android.content.Context
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction

import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider


class TwoWayOtpIdentityProvider(var context: Context) : OneginiCustomIdentityProvider {
    private val registrationAction: OneginiCustomTwoStepRegistrationAction
    override fun getRegistrationAction(): OneginiCustomRegistrationAction {
        return registrationAction
    }

    override fun getId(): String {
        return "2-way-otp-api"
    }

    init {
        registrationAction = TwoWayOtpRegistrationAction(context)
    }
}
