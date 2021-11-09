package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class RegistrationRequestHandler(private val oneginiEventsSender: OneginiEventsSender) : OneginiBrowserRegistrationRequestHandler {

    private var oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback? = null

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

    fun handleRegistrationCallback(uri: Uri) {
        oneginiBrowserRegistrationCallback?.handleRegistrationCallback(uri)
        this.oneginiBrowserRegistrationCallback = null
        CALLBACK = null
    }

    fun onRegistrationCanceled() {
        oneginiBrowserRegistrationCallback?.denyRegistration()
        this.oneginiBrowserRegistrationCallback = null
        CALLBACK = null
    }


    override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
        CALLBACK = oneginiBrowserRegistrationCallback
        this.oneginiBrowserRegistrationCallback = oneginiBrowserRegistrationCallback
        oneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_HANDLE_REGISTERED_URL, uri.toString())))
    }
}
