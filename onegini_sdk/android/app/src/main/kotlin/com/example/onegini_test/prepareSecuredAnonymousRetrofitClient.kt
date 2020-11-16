package com.example.onegini_test

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.adapter.rxjava3.RxJava3CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory


class SecuredResourceClient(private val mainActivity: MainActivity) {
    fun getAnonymousClient(): AnonymousClient {
        val okHttpClient: OkHttpClient? = OneginiSDK.getOneginiClient(mainActivity)?.deviceClient?.anonymousResourceOkHttpClient
        return prepareSecuredRetrofitClient(AnonymousClient::class.java, mainActivity, okHttpClient!!)
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



