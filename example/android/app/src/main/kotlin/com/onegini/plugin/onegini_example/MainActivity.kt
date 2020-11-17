package com.onegini.plugin.onegini_example

import android.content.Intent
import com.onegini.plugin.onegini.OneginiConfigModel
import com.onegini.plugin.onegini.RegistrationHelper
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.data != null)
            RegistrationHelper.handleRegistrationCallback(intent.data)
    }

}
