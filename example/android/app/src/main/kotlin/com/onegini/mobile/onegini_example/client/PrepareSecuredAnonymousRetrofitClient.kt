package com.onegini.mobile.onegini_example.client

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.flutter.OneginiSDK
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory


class SecuredResourceClient(private val context: Context) {
    fun<T> getAnonymousClient(clazz: Class<T>): T? {
        val okHttpClient: OkHttpClient? = OneginiSDK.getOneginiClient(context)?.deviceClient?.anonymousResourceOkHttpClient
        return prepareSecuredRetrofitClient(clazz, context, okHttpClient)
    }

    fun<T> getUserClient(clazz: Class<T>): T?{
        val okHttpClient: OkHttpClient? = OneginiSDK.getOneginiClient(context)?.userClient?.resourceOkHttpClient
        return prepareSecuredRetrofitClient(clazz,context,okHttpClient)

    }

    fun<T> getSecuredImplicitUserRetrofitClient(clazz: Class<T>): T? {
        val okHttpClient = OneginiSDK.getOneginiClient(context)?.userClient?.implicitResourceOkHttpClient
        return prepareSecuredRetrofitClient(clazz, context, okHttpClient)
    }

    private fun <T> prepareSecuredRetrofitClient(clazz: Class<T>, context: Context, okHttpClient: OkHttpClient?): T? {
        val oneginiClient: OneginiClient? = OneginiSDK.getOneginiClient(context)
        if(okHttpClient == null) return null
        val retrofit = Retrofit.Builder()
                .client(okHttpClient)
                .baseUrl(oneginiClient?.configModel?.resourceBaseUrl ?: "")
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create())
                .build()
        return retrofit.create(clazz)
    }
}



