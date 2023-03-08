package com.onegini.mobile.sdk.flutter.useCases

import android.content.Context
import android.content.Intent
import android.net.Uri
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.activity.ActivityWebView
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HandleRegisteredUrlUseCase @Inject constructor(private val context: Context, private val oneginiSDK: OneginiSDK) {
    operator fun invoke(url: String, signInType: Long): Result<Unit> {
        val intent = prepareIntentBasedOnType(signInType.toInt(), context, url)
        context.startActivity(intent)

        return Result.success(Unit)
    }

    private fun prepareIntentBasedOnType(type: Int?, context: Context, url: String): Intent {
        val intent: Intent = if (type == null || type == 0) {
            Intent(context, ActivityWebView::class.java).putExtra("url", url).putExtra("redirectUrl", oneginiSDK.oneginiClient.configModel.redirectUri)
        } else {
            val uri = Uri.parse(url)
            Intent(Intent.ACTION_VIEW, uri)
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
        return intent
    }
}
