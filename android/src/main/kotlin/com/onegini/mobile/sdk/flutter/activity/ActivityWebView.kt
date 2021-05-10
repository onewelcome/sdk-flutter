package com.onegini.mobile.sdk.flutter.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.R
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper

class ActivityWebView : Activity() {

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_webview)
        val redirectUrl = OneginiSDK().getOneginiClient(applicationContext).configModel.redirectUri
        val redirectUri = Uri.parse(redirectUrl)
        val myWebView: WebView = findViewById(R.id.webview)
        myWebView.settings.javaScriptEnabled = true
        myWebView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                val url = request?.url
                Log.e("URL", url.toString())
                Log.e("SCHEME", redirectUri.scheme.toString())
                if (url != null) {
                    if (url.scheme == redirectUri.scheme) {
                        RegistrationHelper.handleRegistrationCallback(url)
                        finish()
                    }
                }
                return super.shouldOverrideUrlLoading(view, request)
            }
        }
        val url = intent.getStringExtra("url")
        if (url == null || url.isEmpty()) {
            RegistrationHelper.cancelRegistration()
            finish()
        } else {
            myWebView.loadUrl(url)
        }
    }
}
