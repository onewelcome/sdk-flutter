package com.onegini.mobile.onegini_example

import android.content.Intent
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            // TODO: Move this logic to outside of the SDK
            // https://onewelcome.atlassian.net/browse/FP-35
            BrowserRegistrationRequestHandler.handleRegistrationCallback(intent.data!!)
        }
    }
}