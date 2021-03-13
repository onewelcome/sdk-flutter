package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.schedulers.Schedulers
import okhttp3.OkHttpClient
import okhttp3.Request

class ResourceHelper (var context: Context,var call: MethodCall,var result: MethodChannel.Result){

    var url : String? = null

    init {
        val oneginiClient: OneginiClient = OneginiSDK.getOneginiClient(context)
        url = oneginiClient.configModel?.resourceBaseUrl ?: ""
    }

    fun getAnonymous(){
        // "application-details"
        //"application/json"
        val request = getRequest()
        val scope = call.argument<String>("scope") ?: "application-details"
        getAnonymousClient(scope,request)
    }

    fun getImplicit(){
       // "read"
        // user-id-decorated
        val request = getRequest()
        val scope = call.argument<String>("scope") ?: "read"
        getSecuredImplicitUserClient(scope, request)
    }

    fun getUserClient(){
        //devices
        val request = getRequest()
        getStandardUserClient(request)

    }


    private fun getAnonymousClient(scope:String,request: Request){
        val okHttpClient: OkHttpClient = OneginiSDK.getOneginiClient(context).deviceClient.anonymousResourceOkHttpClient
        OneginiSDK.getOneginiClient(context).deviceClient?.authenticateDevice(arrayOf(scope), object : OneginiDeviceAuthenticationHandler {
            override fun onSuccess() {
               makeRequest(okHttpClient,request, result)
            }
            override fun onError(error: OneginiDeviceAuthenticationError) {
                result.error(error.errorType.toString(), error.message, error.errorDetails)
            }
        }
        )
    }

    private fun getStandardUserClient(request: Request) {
        val okHttpClient: OkHttpClient = OneginiSDK.getOneginiClient(context).userClient.resourceOkHttpClient
        makeRequest(okHttpClient, request, result)
    }

   private fun getSecuredImplicitUserClient(scope:String,request: Request) {
        val okHttpClient = OneginiSDK.getOneginiClient(context).userClient.implicitResourceOkHttpClient
        val userProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile
        if(userProfile == null){
            result.error(ErrorHelper().authenticatedUserProfileIsNull.code, ErrorHelper().authenticatedUserProfileIsNull.message, null)
            return
        }
        OneginiSDK.getOneginiClient(context).userClient
                ?.authenticateUserImplicitly(userProfile, arrayOf(scope), object : OneginiImplicitAuthenticationHandler {
                    override fun onSuccess(profile: UserProfile) {
                        makeRequest(okHttpClient, request, result)
                    }
                    override fun onError(error: OneginiImplicitTokenRequestError) {
                        result.error(error.errorType.toString(), error.message, error.cause.toString())
                    }
                })
    }

    private fun makeRequest(okHttpClient: OkHttpClient,request: Request,result: MethodChannel.Result){
        Observable.fromCallable { okHttpClient.newCall(request).execute()}
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ data ->
                    result.success(data?.body()?.string())
                }, {
                    result.error("",it.message,it.stackTrace.toString())
                })
    }

    private fun getRequest() : Request{
        val path = call.argument<String>("path")
        val headers = call.argument<String>("headers") ?: ""
        val method = call.argument<String>("method") ?: "GET"
        val encoding = call.argument<String>("encoding") ?: "application/json"
        val body = call.argument<String>("body")
        return RequestMaker.makeRequest(headers,method,"$url$path",encoding,body)
    }
}