package com.onegini.mobile.sdk.utils

import android.os.Parcel
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider

class OnegeniProviderTest : OneginiIdentityProvider {
    override fun describeContents(): Int {
        return 0
    }

    override fun writeToParcel(p0: Parcel?, p1: Int) {
    }
    override fun getId(): String {
        return "test provider id"
    }

    override fun getName(): String {
        return "test provider id"
    }
}
