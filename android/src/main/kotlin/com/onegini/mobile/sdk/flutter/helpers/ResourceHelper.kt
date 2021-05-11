package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiDeviceAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeviceAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Observable
import io.reactivex.rxjava3.schedulers.Schedulers
import okhttp3.Headers
import okhttp3.MediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

class ResourceHelper(private var call: MethodCall, private var result: MethodChannel.Result, private var oneginiClient: OneginiClient) {

    private var url: String? = null

    init {
        url = oneginiClient.configModel.resourceBaseUrl
    }

    fun getAnonymous() {
        // "application-details"
        // "application/json"
        val request = getRequest()
        val scope = call.argument<ArrayList<String>>("scope")
        getAnonymousClient(scope, request)
    }

    fun getImplicit() {
        // "read"
        // user-id-decorated
        val request = getRequest()
        val scope = call.argument<ArrayList<String>>("scope")
        getSecuredImplicitUserClient(scope, request)
    }

    fun getUserClient() {
        // devices
        val request = getRequest()
        getStandardUserClient(request)
    }

    fun getUnauthenticatedResource() {
        val request = getRequest()
        getUnauthenticatedResourceOkHttpClient(request)
    }

    private fun getAnonymousClient(scope: ArrayList<String>?, request: Request) {
        val okHttpClient: OkHttpClient = oneginiClient.deviceClient.anonymousResourceOkHttpClient
        oneginiClient.deviceClient.authenticateDevice(
            scope?.toArray(arrayOfNulls<String>(scope.size)),
            object : OneginiDeviceAuthenticationHandler {
                override fun onSuccess() {
                    makeRequest(okHttpClient, request, result)
                }

                override fun onError(error: OneginiDeviceAuthenticationError) {
                    result.error(error.errorType.toString(), error.message, null)
                }
            }
        )
    }

    private fun getStandardUserClient(request: Request) {
        val okHttpClient: OkHttpClient = oneginiClient.userClient.resourceOkHttpClient
        makeRequest(okHttpClient, request, result)
    }

    private fun getUnauthenticatedResourceOkHttpClient(request: Request) {
        val okHttpClient: OkHttpClient = oneginiClient.deviceClient.unauthenticatedResourceOkHttpClient
        makeRequest(okHttpClient, request, result)
    }

    private fun getSecuredImplicitUserClient(scope: ArrayList<String>?, request: Request) {
        val okHttpClient = oneginiClient.userClient.implicitResourceOkHttpClient
        val userProfile = oneginiClient.userClient.authenticatedUserProfile
        if (userProfile == null) {
            result.error(OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.code, OneginiWrapperErrors.AUTHENTICATED_USER_PROFILE_IS_NULL.message, null)
            return
        }
        oneginiClient.userClient.authenticateUserImplicitly(
            userProfile, scope?.toArray(arrayOfNulls<String>(scope.size)),
            object : OneginiImplicitAuthenticationHandler {
                override fun onSuccess(profile: UserProfile) {
                    makeRequest(okHttpClient, request, result)
                }

                override fun onError(error: OneginiImplicitTokenRequestError) {
                    result.error(error.errorType.toString(), error.message, error.cause.toString())
                }
            }
        )
    }

    private fun makeRequest(okHttpClient: OkHttpClient, request: Request, result: MethodChannel.Result) {
        Observable.fromCallable { okHttpClient.newCall(request).execute() }
            .subscribeOn(Schedulers.io())
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(
                { data ->
                    result.success(data?.body()?.string())
                },
                {
                    result.error("", it.message, it.stackTrace.toString())
                }
            )
    }

    private fun getRequest(): Request {
        val path = call.argument<String>("path")
        val headers = call.argument<HashMap<String, String>>("headers")
        val method = call.argument<String>("method") ?: "GET"
        val encoding = call.argument<String>("encoding") ?: "application/json"
        val body = call.argument<String>("body")
        return prepareRequest(headers, method, "$url$path", encoding, body)
    }

    private fun prepareRequest(headers: HashMap<String, String>?, method: String, url: String, encoding: String, body: String?): Request {
        val request = Request.Builder()
        if (body != null && body.isNotEmpty() && method != "GET" && method != "get") {
            val createdBody = RequestBody.create(MediaType.parse(encoding), body)
            request.method(method, createdBody)
        }
        request.url(url)
        if (headers != null && headers.isNotEmpty()) {
            try {
                request.headers(Headers.of(headers))
            } catch (error: Exception) {
            }
        }

        return request.build()
    }
}
