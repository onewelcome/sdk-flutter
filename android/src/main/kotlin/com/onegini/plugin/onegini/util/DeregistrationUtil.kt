package com.onegini.plugin.onegini.util

import android.content.Context
import android.util.Log
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.storage.UserStorage


class DeregistrationUtil(var context: Context) {
    fun onUserDeregistered(userProfile: UserProfile?) {
        if (userProfile == null) {
            Log.e("DeregistrationUtil", "userProfile == null")
            return
        }
        UserStorage(context).removeUser(userProfile)
    }

    fun onDeviceDeregistered() {
        UserStorage(context).clearStorage()
    }

    init {
        this.context = context
    }
}
