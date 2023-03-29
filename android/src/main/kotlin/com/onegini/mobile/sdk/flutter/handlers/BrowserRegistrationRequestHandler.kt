package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

// TODO Put functions into use cases; https://onewelcome.atlassian.net/browse/FP-35
@Singleton
class BrowserRegistrationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi): OneginiBrowserRegistrationRequestHandler {

    companion object {
        var callback: OneginiBrowserRegistrationCallback? = null

        /**
         * Finish registration action with result from web browser
         * TODO: Move this to use-case after browser logic rework
         * https://onewelcome.atlassian.net/browse/FP-35
         */
        fun handleRegistrationCallback(uri: Uri) {
            if (callback != null) {
                callback?.handleRegistrationCallback(uri)
                callback = null
            }
        }
    }

    override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
        callback = oneginiBrowserRegistrationCallback
        nativeApi.n2fHandleRegisteredUrl(uri.toString()) {}
    }
}
