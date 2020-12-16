package com.onegini.plugin.onegini.model

import com.onegini.mobile.sdk.android.model.entity.UserProfile


class User(var userProfile: UserProfile, var name: String) {

    override fun toString(): String {
        return name + " (id: " + userProfile.profileId + ")"
    }

}
