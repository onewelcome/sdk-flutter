package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_BODY
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_HEADERS
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_STATUS_CODE
import com.onegini.mobile.sdk.flutter.constants.Constants.Companion.RESPONSE_URL
import io.flutter.plugin.common.MethodChannel
import okhttp3.Response

class SdkError {
    private val title: String
    private val code: Int
    private val message: String
    private val info: Map<String, Any>
    private val httpResponse: Response?

    constructor(
        title: String = "Error",
        code: Int = GENERIC_ERROR.code,
        message: String? = GENERIC_ERROR.message,
        info: Map<String, Any> = emptyMap(),
        httpResponse: Response? = null
    ) {
        this.title = title
        this.code = code
        this.message = when(message) {
            null -> GENERIC_ERROR.message
            else -> message
        }
        this.info = info
        this.httpResponse = httpResponse
    }

    constructor(
        wrapperError: OneWelcomeWrapperErrors,
        title: String = "Error",
        info: Map<String, Any> = emptyMap(),
        httpResponse: Response? = null
    ) {
        this.title = title
        this.code = wrapperError.code
        this.message = wrapperError.message
        this.info = info
        this.httpResponse = httpResponse
    }

    private fun getResponseDetails(): MutableMap<String, Any> {
        val response: MutableMap<String, Any> = mutableMapOf()

        if (httpResponse != null) {
            response[RESPONSE_URL] = httpResponse.request.url.toString()
            response[RESPONSE_STATUS_CODE] = httpResponse.code.toString()
            response[RESPONSE_HEADERS] = httpResponse.headers.toMap()

            val bodyString = httpResponse.body?.string()
            if (bodyString != null) {
                response[RESPONSE_BODY] = bodyString
            }
        }

        return response
    }

    private fun getDetails(): MutableMap<String, Any> {
        val details: MutableMap<String, Any> = mutableMapOf()
        details["title"] = title
        details["code"] = code.toString()
        details["message"] = message
        details["userInfo"] = info
        details["response"] = getResponseDetails()

        return details
    }

    fun flutterError(result: MethodChannel.Result) {
        result.error(code.toString(), message, getDetails())
    }
}