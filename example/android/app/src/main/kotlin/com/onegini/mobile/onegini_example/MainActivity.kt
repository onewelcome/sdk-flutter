package com.onegini.mobile.onegini_example

import android.content.Intent
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            BrowserRegistrationRequestHandler.handleRegistrationCallback(intent.data!!)
        }
    }
}
