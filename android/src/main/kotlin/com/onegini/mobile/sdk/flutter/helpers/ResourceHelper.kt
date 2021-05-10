package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.schedulers.Schedulers
import okhttp3.*
import java.util.*

class ResourceHelper {

    fun callRequest(okHttpClient: OkHttpClient, request: Request, result: MethodChannel.Result) {
        Observable.fromCallable { okHttpClient.newCall(request).execute() }
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        { data ->
                            result.success(data?.body()?.string())
                        },
                        {
                            result.error(OneginiWrapperErrors.HTTP_REQUEST_ERROR.code, it.message, null)
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
            val createdBody = RequestBody.create(MediaType.parse(encoding), body)
            builder.method(method, createdBody)
        }
    }

    private fun prepareHeadersForRequest(builder: Request.Builder, headers: HashMap<String, String>?) {
        if (headers != null && headers.isNotEmpty()) {
            builder.headers(Headers.of(headers))
        }
    }

    private fun prepareUrlForRequest(builder: Request.Builder, url: String, params: HashMap<String, String>?) {
        val urlBuilder = HttpUrl.parse(url)?.newBuilder()

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
