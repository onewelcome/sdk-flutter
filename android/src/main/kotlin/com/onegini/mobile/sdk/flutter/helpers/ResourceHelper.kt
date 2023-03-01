package com.onegini.mobile.sdk.flutter.helpers

import com.google.gson.Gson
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_BODY
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_HEADERS
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_STATUS_CODE
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_URL

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
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.collections.HashMap

@Singleton
class ResourceHelper @Inject constructor() {

    fun callRequest(okHttpClient: OkHttpClient, request: Request, result: MethodChannel.Result) {
        Observable.fromCallable { okHttpClient.newCall(request).execute() }
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        { data ->
                            if (data.code >= 400) {
                                    SdkError(
                                        wrapperError = ERROR_CODE_HTTP_REQUEST,
                                        httpResponse = data
                                    ).flutterError(result)
                            } else {
                                val response = Gson().toJson(mapOf(
                                    RESPONSE_STATUS_CODE to data.code,
                                    RESPONSE_BODY to data.body?.string(),
                                    RESPONSE_HEADERS to data.headers,
                                    RESPONSE_URL to data.request.url.toString()))
                                result.success(response)
                            }
                        },
                        {
                            if (it.message != null) {
                                SdkError(
                                    code = HTTP_REQUEST_ERROR.code,
                                    message = it.message.toString()
                                ).flutterError(result)
                            } else {
                                SdkError(HTTP_REQUEST_ERROR).flutterError(result)
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
