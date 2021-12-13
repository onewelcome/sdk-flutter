package com.onegini.mobile.onegini_example

import android.content.Intent
import android.os.Bundle
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import io.flutter.embedding.android.FlutterActivity


class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }


    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null) {
            RegistrationRequestHandler.handleRegistrationCallback(intent.data!!)
        }
    }
}
