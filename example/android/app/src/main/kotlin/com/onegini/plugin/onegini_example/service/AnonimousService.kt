package com.onegini.plugin.onegini_example.service


import android.app.Activity
import android.content.Context
import com.onegini.plugin.onegini_example.client.SecuredResourceClient
import com.onegini.plugin.onegini_example.client.AnonymousClient
import com.onegini.plugin.onegini_example.client.ApplicationDetails
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.schedulers.Schedulers


class AnonymousService constructor(context: Context) {
    private val applicationDetailsRetrofitClient: AnonymousClient? = SecuredResourceClient(context).getAnonymousClient(AnonymousClient::class.java)
    val applicationDetails: Single<ApplicationDetails>?
        get() = applicationDetailsRetrofitClient?.getApplicationDetails()
                ?.subscribeOn(Schedulers.io())
                ?.observeOn(AndroidSchedulers.mainThread())

}