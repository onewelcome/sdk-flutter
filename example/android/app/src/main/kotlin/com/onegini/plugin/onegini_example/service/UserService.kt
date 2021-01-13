package com.onegini.plugin.onegini_example.service

import android.app.Activity
import com.onegini.plugin.onegini_example.client.DevicesResponse
import com.onegini.plugin.onegini_example.client.UserClient
import com.onegini.plugin.onegini_example.client.SecuredResourceClient
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers


class UserService constructor(activity: Activity) {
    private val userServiceRetrofitClient: UserClient? = SecuredResourceClient(activity).getUserClient(UserClient::class.java)
    val devices :  Single<DevicesResponse>?
        get() = userServiceRetrofitClient?.getDevices()
                ?.subscribeOn(Schedulers.io())
                ?.observeOn(AndroidSchedulers.mainThread())

}