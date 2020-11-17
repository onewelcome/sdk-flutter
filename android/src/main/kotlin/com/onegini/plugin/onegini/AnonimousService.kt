package com.onegini.plugin.onegini


import android.app.Activity

import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.schedulers.Schedulers


class AnonymousService constructor(activity: Activity) {
    private val applicationDetailsRetrofitClient: AnonymousClient = SecuredResourceClient(activity).getAnonymousClient()
    val applicationDetails: Single<ApplicationDetails>
        get() = applicationDetailsRetrofitClient.getApplicationDetails()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())

}