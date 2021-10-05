package com.onegini.mobile.sdk.flutter.useCases

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import io.flutter.plugin.common.MethodCall

class HandleRegisteredUrlUseCase {
    operator fun invoke(call: MethodCall, context: Context) {
        val url = call.argument<String>("url") ?: ""
        val isInAppBrowser = call.argument<Int>("type")
        if (isInAppBrowser == null || isInAppBrowser == 0){
            val customTabsIntent = CustomTabsIntent.Builder().build()
            customTabsIntent.intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            customTabsIntent.intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            customTabsIntent.launchUrl(context, Uri.parse(url))
        }else {
            val uri = Uri.parse(url)
            val intent = Intent(Intent.ACTION_VIEW, uri)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
            context.startActivity(intent)
        }

    }
}