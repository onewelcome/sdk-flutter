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
    private val code: Int
    private val message: String
    private val details: MutableMap<String, Any> = mutableMapOf()

    // Only error codes
    constructor(
        code: Int,
        message: String?,
    ) {
        this.code = code
        this.message = message ?: GENERIC_ERROR.message

        setGenericDetails()
    }

    constructor(
        wrapperError: OneWelcomeWrapperErrors
    ) {
        this.code = wrapperError.code
        this.message = wrapperError.message

        setGenericDetails()
    }

    // Error codes with httpResponse information
    constructor(
        code: Int,
        message: String?,
        httpResponse: Response?,
    ) {
        this.code = code
        this.message = message ?: GENERIC_ERROR.message

        setGenericDetails()
        setResponseDetails(httpResponse)
    }

    constructor(
        wrapperError: OneWelcomeWrapperErrors,
        httpResponse: Response?,
    ) {
        this.code = wrapperError.code
        this.message = wrapperError.message

        setGenericDetails()
        setResponseDetails(httpResponse)
    }

    private fun setGenericDetails() {
        details["code"] = code.toString()
        details["message"] = message
    }

    private fun setInfoDetails(info: Map<String, Any>?) {
        when (info) {
            null -> details["userInfo"] = emptyMap<String, Any>()
            else -> details["userInfo"] = info
        }
    }

    private fun setResponseDetails(httpResponse: Response?) {
        val response: MutableMap<String, Any> = mutableMapOf()

        if (httpResponse != null) {
            response[RESPONSE_URL] = httpResponse.request.url.toString()
            response[RESPONSE_STATUS_CODE] = httpResponse.code.toString()
            response[RESPONSE_HEADERS] = httpResponse.headers.toMap()

            val bodyString = httpResponse.body?.string()

            response[RESPONSE_BODY] = when (bodyString) {
                null -> ""
                else -> bodyString
            }
        }

        details["response"] = response
    }

    fun flutterError(result: MethodChannel.Result) {
        result.error(code.toString(), message, details)
    }
}