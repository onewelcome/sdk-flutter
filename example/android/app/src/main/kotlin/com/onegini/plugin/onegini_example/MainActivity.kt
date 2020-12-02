package com.onegini.plugin.onegini_example

import android.content.Intent
import android.os.Bundle
import com.onegini.plugin.onegini.RegistrationHelper
import com.onegini.plugin.onegini.StorageIdentityProviders
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        StorageIdentityProviders.oneginiCustomIdentityProviders.add(TwoWayOtpIdentityProvider(this.applicationContext))
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null)
            RegistrationHelper.handleRegistrationCallback(intent.data)
    }

}
