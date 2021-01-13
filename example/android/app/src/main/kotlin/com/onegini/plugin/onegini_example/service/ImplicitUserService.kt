package com.onegini.plugin.onegini_example.service

import android.app.Activity
import com.onegini.plugin.onegini_example.client.ImplicitUserClient
import com.onegini.plugin.onegini_example.client.ImplicitUserDetails
import com.onegini.plugin.onegini_example.client.SecuredResourceClient
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers


class ImplicitUserService constructor(activity: Activity) {
    private val implicitUserServiceRetrofitClient: ImplicitUserClient? = SecuredResourceClient(activity).getSecuredImplicitUserRetrofitClient(ImplicitUserClient::class.java)
    val userDetails : Single<ImplicitUserDetails>?
        get() = implicitUserServiceRetrofitClient?.getImplicitUserDetails()
                ?.subscribeOn(Schedulers.io())
                ?.observeOn(AndroidSchedulers.mainThread())

}