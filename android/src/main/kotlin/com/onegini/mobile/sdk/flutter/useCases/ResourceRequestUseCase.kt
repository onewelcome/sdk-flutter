package com.onegini.mobile.sdk.flutter.useCases

import android.util.Patterns
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ERROR_CODE_HTTP_REQUEST
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.HTTP_REQUEST_ERROR
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestDetails
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRequestResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.ResourceRequestType
import com.onegini.mobile.sdk.flutter.pigeonPlugin.HttpRequestMethod.GET
import com.onegini.mobile.sdk.flutter.pigeonPlugin.HttpRequestMethod.POST
import com.onegini.mobile.sdk.flutter.pigeonPlugin.HttpRequestMethod.PUT
import com.onegini.mobile.sdk.flutter.pigeonPlugin.HttpRequestMethod.DELETE
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Headers
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import java.io.IOException
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ResourceRequestUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(type: ResourceRequestType, details: OWRequestDetails, callback: (Result<OWRequestResponse>) -> Unit) {
    val resourceClient = getOkHttpClient(type)
    val request = buildRequest(details)

    performCall(resourceClient, request, callback)
  }

  private fun getOkHttpClient(type: ResourceRequestType): OkHttpClient {
    return when (type) {
      ResourceRequestType.AUTHENTICATED -> oneginiSDK.oneginiClient.userClient.resourceOkHttpClient
      ResourceRequestType.IMPLICIT -> oneginiSDK.oneginiClient.userClient.implicitResourceOkHttpClient
      ResourceRequestType.ANONYMOUS -> oneginiSDK.oneginiClient.deviceClient.anonymousResourceOkHttpClient
      ResourceRequestType.UNAUTHENTICATED -> oneginiSDK.oneginiClient.deviceClient.unauthenticatedResourceOkHttpClient
    }
  }

  private fun buildRequest(details: OWRequestDetails): Request {
    return Request.Builder()
      .url(getCompleteResourceUrl(details.path))
      .headers(getHeaders(details.headers))
      .setMethod(details)
      .build()
  }

  private fun getCompleteResourceUrl(path: String): Result<String> {
    val resourceBaseUrl = oneginiSDK.oneginiClient.configModel.resourceBaseUrl

    return when {
      isValidUrl(path) -> Result.success(path)
      isValidUrl(path + resourceBaseUrl) -> Result.success(path + resourceBaseUrl)
      else -> Result.failure(
        SdkError(
          wrapperError = HTTP_REQUEST_ERROR
        ).pigeonError()
      )
    }
  }

  private fun isValidUrl(path: String): Boolean {
    return Patterns.WEB_URL.matcher(path).matches()
  }

  private fun getHeaders(headers: Map<String?, String?>?): Headers {
    val headerBuilder = Headers.Builder()

    // Pigeon 9.0.5 limits enforcing non null values in maps
    headers?.entries
      ?.filter { it.key is String && it.value is String }
      ?.forEach { headerBuilder.add(it.key as String, it.value as String) }

    return headerBuilder.build()
  }

  private fun Request.Builder.setMethod(details: OWRequestDetails): Request.Builder {
    return when (details.method) {
      GET -> {
        this.get()
      }
      POST -> {
        val body = details.body ?: ""
        this.post(body.toRequestBody(null))
      }
      PUT -> {
        val body = details.body ?: ""
        this.put(body.toRequestBody(null))
      }
      DELETE -> {
        this.delete(details.body?.toRequestBody())
      }
    }
  }

  private fun performCall(okHttpClient: OkHttpClient, request: Request, callback: (Result<OWRequestResponse>) -> Unit) {
    okHttpClient.newCall(request).enqueue(object : Callback {
      override fun onFailure(call: Call, e: IOException) {
        callback(
          Result.failure(
            SdkError(
              code = HTTP_REQUEST_ERROR.code,
              message = e.message.toString()
            ).pigeonError()
          )
        )
      }

      override fun onResponse(call: Call, response: Response) {
        // Fail on non-successful http-codes to align behaviour with iOS
        if (response.code >= 400) {
          callback(
            Result.failure(
              SdkError(
                wrapperError = ERROR_CODE_HTTP_REQUEST,
                httpResponse = response
              ).pigeonError()
            )
          )
        } else {
          val owResponse = OWRequestResponse(
            headers = response.headers.toMap(),
            body = response.body?.string() ?: "",
            ok = response.isSuccessful,
            status = response.code.toLong()
          )

          callback(Result.success(owResponse))
        }
      }
    })
  }
}
