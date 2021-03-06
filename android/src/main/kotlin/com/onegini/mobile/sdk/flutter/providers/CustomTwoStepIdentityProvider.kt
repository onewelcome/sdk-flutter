package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomTwoStepRegistrationAction
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider

class CustomTwoStepIdentityProvider(private val providerId: String) : OneginiCustomIdentityProvider {

    private val registrationAction: OneginiCustomTwoStepRegistrationAction
    override fun getRegistrationAction(): OneginiCustomRegistrationAction {
        return registrationAction
    }

    override fun getId(): String {
        return providerId
    }

    init {
        registrationAction = CustomTwoStepRegistrationAction(providerId)
    }
}
