package com.onegini.mobile.sdk.flutter.activity

import android.annotation.SuppressLint
import android.app.Activity
import android.net.Uri
import android.os.Bundle
import android.webkit.WebView
import android.webkit.WebViewClient
import com.onegini.mobile.sdk.flutter.R
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper

class ActivityWebView : Activity() {

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.layout_webview)
        val myWebView: WebView = findViewById(R.id.webview)
        myWebView.settings.javaScriptEnabled = true
        myWebView.webViewClient = object : WebViewClient() {
            override fun onLoadResource(view: WebView?, url: String?) {
                super.onLoadResource(view, url)
                val uri = Uri.parse(url)
                if (uri.scheme != "http" && uri.scheme != "https") {
                    RegistrationHelper.handleRegistrationCallback(uri)
                    finish()
                }
            }
        }
        myWebView.loadUrl(intent.getStringExtra("url")!!)
    }
}
