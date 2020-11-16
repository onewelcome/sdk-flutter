package com.example.onegini_test


import android.content.Context
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.schedulers.Schedulers


class AnonymousService constructor(mainActivity: Context) {
    private val applicationDetailsRetrofitClient: AnonymousClient = SecuredResourceClient(mainActivity).getAnonymousClient()
    val applicationDetails: Single<ApplicationDetails>
        get() = applicationDetailsRetrofitClient.getApplicationDetails()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())

}