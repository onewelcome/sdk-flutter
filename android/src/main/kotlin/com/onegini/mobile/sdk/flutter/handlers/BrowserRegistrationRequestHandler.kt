package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

// TODO Put functions into use cases; https://onewelcome.atlassian.net/browse/FP-35
class BrowserRegistrationRequestHandler : OneginiBrowserRegistrationRequestHandler {

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
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_HANDLE_REGISTERED_URL, uri.toString())))
    }
}
