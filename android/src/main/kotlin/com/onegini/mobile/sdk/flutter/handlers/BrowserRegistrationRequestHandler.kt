package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent
import javax.inject.Inject
import javax.inject.Singleton

// TODO Put functions into use cases; https://onewelcome.atlassian.net/browse/FP-35
@Singleton
class BrowserRegistrationRequestHandler @Inject constructor(): OneginiBrowserRegistrationRequestHandler {

    companion object {
        var CALLBACK: OneginiBrowserRegistrationCallback? = null

        /**
         * Finish registration action with result from web browser
         * TODO: Move this to use-case after browser logic rework
         * https://onewelcome.atlassian.net/browse/FP-35
         */
        fun handleRegistrationCallback(uri: Uri) {
            if (CALLBACK != null) {
                CALLBACK?.handleRegistrationCallback(uri)
                CALLBACK = null
            }
        }
    }

    override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
        CALLBACK = oneginiBrowserRegistrationCallback
        OneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_HANDLE_REGISTERED_URL, uri.toString())))
    }
}
