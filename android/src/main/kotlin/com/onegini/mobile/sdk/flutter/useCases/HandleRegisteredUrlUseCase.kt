package com.onegini.mobile.sdk.flutter.useCases

import android.content.Context
import android.content.Intent
import android.net.Uri
import com.onegini.mobile.sdk.flutter.activity.ActivityWebView
import io.flutter.plugin.common.MethodCall

class HandleRegisteredUrlUseCase {
    operator fun invoke(call: MethodCall, context: Context) {
        val url = call.argument<String>("url") ?: ""
        val isInAppBrowser = call.argument<Int>("type")
        val intent = prepareIntentBasedOnType(isInAppBrowser, context, url)
        context.startActivity(intent)
    }

    private fun prepareIntentBasedOnType(type: Int?, context: Context, url: String): Intent {
        val intent: Intent = if (type == null || type == 0) {
            Intent(context, ActivityWebView::class.java).putExtra("url", url)
        } else {
            val uri = Uri.parse(url)
            Intent(Intent.ACTION_VIEW, uri)
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
        return intent
    }
}