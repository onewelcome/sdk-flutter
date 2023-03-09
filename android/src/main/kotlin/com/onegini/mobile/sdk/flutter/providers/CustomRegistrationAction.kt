package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import io.flutter.plugin.common.MethodChannel

interface CustomRegistrationAction {
    fun getCustomRegistrationAction(): OneginiCustomRegistrationAction

    fun getIdProvider(): String

    fun returnSuccess(result: String?, pigeonCallback: (Result<Unit>) -> Unit)

    fun returnError(exception: Exception?, pigeonCallback: (Result<Unit>) -> Unit)
}
