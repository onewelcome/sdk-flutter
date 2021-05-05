package com.onegini.mobile.sdk.flutter.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import com.onegini.mobile.sdk.flutter.OneginiMethodsWrapper
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.R
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler

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
            override fun onLoadResource(view: WebView?, url: String?) {
                super.onLoadResource(view, url)
                val uri = Uri.parse(url)
                if (uri.scheme == redirectUri.scheme) {
                    RegistrationRequestHandler.handleRegistrationCallback(uri)
                    finish()
                }
            }
        }
        val url = intent.getStringExtra("url")
        if (url == null || url.isEmpty()) {
            OneginiMethodsWrapper().cancelRegistration()
            finish()
        } else {
            myWebView.loadUrl(url)
        }
    }
}
