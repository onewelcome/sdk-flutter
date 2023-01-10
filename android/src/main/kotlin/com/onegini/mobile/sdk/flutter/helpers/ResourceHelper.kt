package com.onegini.mobile.sdk.flutter.helpers

import com.google.gson.Gson
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.schedulers.Schedulers
import okhttp3.Headers.Companion.toHeaders
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.Locale
import kotlin.collections.HashMap

class ResourceHelper {

    fun callRequest(okHttpClient: OkHttpClient, request: Request, result: MethodChannel.Result) {
        Observable.fromCallable { okHttpClient.newCall(request).execute() }
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        { data ->
                            if (data.code >= 400) {
                                    SdkError(
                                        wrapperError = OneWelcomeWrapperErrors.ERROR_CODE_HTTP_REQUEST,
                                        httpResponse = data
                                    ).flutterError(result)
                            } else {
                                val response = Gson().toJson(mapOf("statusCode" to data.code, "body" to data.body?.string(), "headers" to data.headers, "url" to data.request.url.toString()))
                                result.success(response)
                            }
                        },
                        {
                            if (it.message != null) {
                                SdkError(
                                    code = OneWelcomeWrapperErrors.HTTP_REQUEST_ERROR.code,
                                    message = it.message.toString()
                                ).flutterError(result)
                            } else {
                                SdkError(
                                    wrapperError = OneWelcomeWrapperErrors.HTTP_REQUEST_ERROR,
                                ).flutterError(result)
                            }
                        }
                )
    }

    fun getRequest(call: MethodCall, url: String): Request {
        val path = call.argument<String>("path")
        val headers = call.argument<HashMap<String, String>>("headers")
        val method = call.argument<String>("method") ?: "GET"
        val encoding = call.argument<String>("encoding") ?: "application/json"
        val params = call.argument<HashMap<String, String>>("parameters")
        val body = call.argument<String>("body")
        return prepareRequest(headers, method, "$url$path", encoding, body, params)
    }

    private fun prepareRequest(headers: HashMap<String, String>?, method: String, url: String, encoding: String, body: String?, params: HashMap<String, String>?): Request {
        val builder = Request.Builder()
        prepareBodyForRequest(builder, body, method, encoding)
        prepareUrlForRequest(builder, url, params)
        prepareHeadersForRequest(builder, headers)
        return builder.build()
    }

    private fun prepareBodyForRequest(builder: Request.Builder, body: String?, method: String, encoding: String) {
        if (body != null && body.isNotEmpty() && method.toUpperCase(Locale.ROOT) != "GET") {
            val createdBody = body.toRequestBody(encoding.toMediaTypeOrNull())
            builder.method(method, createdBody)
        }
    }

    private fun prepareHeadersForRequest(builder: Request.Builder, headers: HashMap<String, String>?) {
        if (headers != null && headers.isNotEmpty()) {
            builder.headers(headers.toHeaders())
        }
    }

    private fun prepareUrlForRequest(builder: Request.Builder, url: String, params: HashMap<String, String>?) {
        val urlBuilder = url.toHttpUrlOrNull()?.newBuilder()

        params?.forEach {
            urlBuilder?.addQueryParameter(it.key, it.value)
        }

        val httpUrl = urlBuilder?.build()

        if (httpUrl != null) {
            builder.url(httpUrl)
        } else {
            builder.url(url)
        }
    }
}
