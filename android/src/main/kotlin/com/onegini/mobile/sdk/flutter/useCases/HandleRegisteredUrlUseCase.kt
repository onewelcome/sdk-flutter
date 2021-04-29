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
        var intent : Intent? = null
        intent = if(isInAppBrowser == null || isInAppBrowser == 0){
            Intent(context, ActivityWebView::class.java).putExtra("url", url)
        }else{
            val uri = Uri.parse(url)
            Intent(Intent.ACTION_VIEW, uri)
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
        context.startActivity(intent)
    }
}