package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction

interface CustomRegistrationAction {
    fun getCustomRegistrationAction(): OneginiCustomRegistrationAction

    fun getIdProvider(): String

    fun returnSuccess(result: String?): Result<Unit>

    fun returnError(exception: Exception?): Result<Unit>
}
