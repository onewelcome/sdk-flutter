package com.onegini.mobile.flutterExample

import android.content.Intent
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            // TODO: Move this logic to outside of the SDK
            // https://onewelcome.atlassian.net/browse/FP-35
            BrowserRegistrationRequestHandler.handleRegistrationCallback(intent.data!!)
        }
    }
}
