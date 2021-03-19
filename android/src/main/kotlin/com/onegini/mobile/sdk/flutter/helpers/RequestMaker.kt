package com.onegini.mobile.sdk.flutter.helpers

import okhttp3.Headers
import okhttp3.MediaType
import okhttp3.Request
import okhttp3.RequestBody

object RequestMaker {
    fun makeRequest(headers:String,method:String,url:String,encoding:String,body :String? ) : Request{
        val request = Request.Builder()
        if(body!=null && body.isNotEmpty()){
            val createdBody = RequestBody.create(MediaType.parse(encoding),body)
            request.method(method, createdBody)
        }
        request.url(url)
        //request.headers(Headers.of(headers))

        return request.build()
    }
}