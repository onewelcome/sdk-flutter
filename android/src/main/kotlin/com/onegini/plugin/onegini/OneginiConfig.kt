package com.onegini.plugin.onegini

import android.os.Build
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel


class OneginiConfigModel : OneginiClientConfigModel {
    private val appIdentifier = "ExampleApp"
    private val appPlatform = "android"
    private val redirectionUri = "oneginiexample://loginsuccess"
    private val appVersion = "6.0.0"
    private val baseURL = "https://token-mobile.test.onegini.com"
    private val resourceBaseURL = "https://token-mobile.test.onegini.com/resources/"
    private val keystoreHash = "ebbcab87e2d16b9441559767a7c85fbaea9a3feef94451990423019a31e5bf1f"
    override fun getAppIdentifier(): String {
        return appIdentifier
    }

    override fun getAppPlatform(): String {
        return appPlatform
    }

    override fun getRedirectUri(): String {
        return redirectionUri
    }

    override fun getAppVersion(): String {
        return appVersion
    }

    override fun getBaseUrl(): String {
        return baseURL
    }

    override fun getResourceBaseUrl(): String {
        return resourceBaseURL
    }

    override fun getCertificatePinningKeyStore(): Int {
        return R.raw.keystore
    }

    override fun getKeyStoreHash(): String {
        return keystoreHash
    }

    override fun getDeviceName(): String {
        return Build.BRAND + " " + Build.MODEL
    }
}