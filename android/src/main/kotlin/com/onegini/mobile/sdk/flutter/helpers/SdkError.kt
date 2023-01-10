package com.onegini.mobile.sdk.flutter.helpers

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import io.flutter.plugin.common.MethodChannel
import okhttp3.Response

class SdkError(
    private val title: String = "Error",
    private var code: Int = OneWelcomeWrapperErrors.GENERIC.code,
    private var message: String? = OneWelcomeWrapperErrors.GENERIC.message,
    private val info: Map<String, Any> = emptyMap(),
    private val wrapperError: OneWelcomeWrapperErrors? = null,
    val httpResponse: Response? = null,
) {
    private var finalMessage :String = OneWelcomeWrapperErrors.GENERIC.message

    private fun getResponseDetails(): MutableMap<Any, Any> {
        val response: MutableMap<Any, Any> = mutableMapOf()

        if (httpResponse != null) {
            response["url"] = httpResponse.request.url.toString()
            response["statusCode"] = httpResponse.code.toString()
            response["headers"] = httpResponse.headers.toMap()

            val bodyString = httpResponse.body?.string()
            if (bodyString != null) {
                response["body"] = bodyString
            }
        }

        return response
    }

    private fun getDetails(): MutableMap<Any, Any> {
        val details: MutableMap<Any, Any> = mutableMapOf()
        details["title"] = title
        details["code"] = code.toString()
        details["message"] = finalMessage
        details["userInfo"] = info
        details["response"] = getResponseDetails()

        return details
    }

    fun flutterError(result: MethodChannel.Result) {
        // overwrite when a wrapper error is given
        if (wrapperError != null) {
            code = wrapperError.code
            finalMessage = wrapperError.message
        } else if (message != null) {
            finalMessage = message as String
        }

        result.error(code.toString(), finalMessage, getDetails())
    }
}