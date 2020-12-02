package com.onegini.plugin.onegini

import android.app.Activity
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers


class UserService constructor(activity: Activity) {
    private val userServiceRetrofitClient: UserClient = SecuredResourceClient(activity).getUserClient()
    val devices :  Single<DevicesResponse>
        get() = userServiceRetrofitClient.getDevices()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())

}