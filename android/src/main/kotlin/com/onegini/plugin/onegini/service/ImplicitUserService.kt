package com.onegini.plugin.onegini.service

import android.app.Activity
import com.onegini.plugin.onegini.client.ImplicitUserClient
import com.onegini.plugin.onegini.client.ImplicitUserDetails
import com.onegini.plugin.onegini.client.SecuredResourceClient
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers

class ImplicitUserService constructor(activity: Activity) {
    private val implicitUserServiceRetrofitClient: ImplicitUserClient? = SecuredResourceClient(activity).getSecuredImplicitUserRetrofitClient()
    val userDetails : Single<ImplicitUserDetails>?
        get() = implicitUserServiceRetrofitClient?.getImplicitUserDetails()
                ?.subscribeOn(Schedulers.io())
                ?.observeOn(AndroidSchedulers.mainThread())

}