package com.onegini.mobile.sdk.utils

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile

class OneginiAuthenticator : OneginiAuthenticator {
    override fun getId(): String {
        return "test id"
    }

    override fun getType(): Int {
        return 0
    }

    override fun getName(): String {
        return "test name"
    }

    override fun isRegistered(): Boolean {
        TODO("Not yet implemented")
    }

    override fun isPreferred(): Boolean {
        TODO("Not yet implemented")
    }

    override fun getUserProfile(): UserProfile {
        TODO("Not yet implemented")
    }
}