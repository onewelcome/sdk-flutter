package com.onegini.mobile.sdk.flutter.handlers

import android.content.Context
import android.content.Intent
import android.net.Uri
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback


class RegistrationRequestHandler(var context: Context) : OneginiBrowserRegistrationRequestHandler {


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

        val intent = Intent(Intent.ACTION_VIEW, uri)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
        context.startActivity(intent)
    }

}