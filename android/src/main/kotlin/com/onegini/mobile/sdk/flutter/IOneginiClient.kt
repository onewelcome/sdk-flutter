package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider

interface IOneginiClient {
    fun getOneginiClient(context: Context): OneginiClient

    fun initSDK(
            context: Context,
            httpConnectionTimeout: Long? = 5,
            httpReadTimeout: Long? = 25,
            oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider> = mutableListOf(),
    ): OneginiClient
}