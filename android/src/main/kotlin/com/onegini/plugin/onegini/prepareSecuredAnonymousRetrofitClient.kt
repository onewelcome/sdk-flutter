package com.onegini.plugin.onegini

import android.app.Activity
import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.adapter.rxjava3.RxJava3CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory


class SecuredResourceClient(private val activity: Activity) {
    fun getAnonymousClient(): AnonymousClient {
        val okHttpClient: OkHttpClient? = OneginiSDK.getOneginiClient(activity)?.deviceClient?.anonymousResourceOkHttpClient
        return prepareSecuredRetrofitClient(AnonymousClient::class.java, activity, okHttpClient!!)
    }

    fun getUserClient(): UserClient {
        val okHttpClient: OkHttpClient? = OneginiSDK.getOneginiClient(activity)?.userClient?.resourceOkHttpClient
        return prepareSecuredRetrofitClient(UserClient::class.java,activity,okHttpClient!!)

    }

    fun getSecuredImplicitUserRetrofitClient(): ImplicitUserClient {
        val okHttpClient = OneginiSDK.getOneginiClient(activity)?.userClient?.implicitResourceOkHttpClient
        return prepareSecuredRetrofitClient(ImplicitUserClient::class.java, activity, okHttpClient!!)
    }


    private fun <T> prepareSecuredRetrofitClient(clazz: Class<T>, context: Context, okHttpClient: OkHttpClient): T {
        val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(context)!!
        val retrofit = Retrofit.Builder()
                .client(okHttpClient)
                .baseUrl(oneginiClient.configModel.resourceBaseUrl)
                .addConverterFactory(GsonConverterFactory.create())
                .addCallAdapterFactory(RxJava3CallAdapterFactory.create())
                .build()
        return retrofit.create(clazz)
    }
}



