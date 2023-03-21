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
        private var CALLBACK: OneginiBrowserRegistrationCallback? = null

        /**
         * Finish registration action with result from web browser
         */
        fun handleRegistrationCallback(uri: Uri) {
            if (CALLBACK != null) {
                CALLBACK?.handleRegistrationCallback(uri)
                CALLBACK = null
            }
        }

        /**
         * Cancel registration action in case of web browser error
         */
        fun onRegistrationCanceled() {
            if (CALLBACK != null) {
                CALLBACK?.denyRegistration()
                CALLBACK = null
            }
        }
    }

    override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
        CALLBACK = oneginiBrowserRegistrationCallback
        nativeApi.n2fHandleRegisteredUrl(uri.toString()) {}
    }
}
