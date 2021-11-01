package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.OneginiEvent

class RegistrationRequestHandler(private val oneginiEventsSender: OneginiEventsSender) : OneginiBrowserRegistrationRequestHandler {

    companion object {
         var CALLBACK: OneginiBrowserRegistrationCallback? = null
        /**
         * Finish registration action with result from web browser
         */
        fun handleRegistrationCallback(uri: Uri) {
            if (CALLBACK != null) {
                CALLBACK?.handleRegistrationCallback(uri)
                CALLBACK = null
            }
        }

        fun onRegistrationCanceled() {
            if(CALLBACK!=null) {
                CALLBACK?.denyRegistration()
                CALLBACK = null
            }
        }
    }

    fun onRegistrationCanceled(oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback?) {
        oneginiBrowserRegistrationCallback?.denyRegistration()
        CALLBACK = null
    }

    /**
     * Cancel registration action in case of web browser error
     */


    override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
        CALLBACK = oneginiBrowserRegistrationCallback
        oneginiEventsSender.events?.success(Gson().toJson(OneginiEvent(Constants.EVENT_HANDLE_REGISTERED_URL, uri.toString())))
    }
}
