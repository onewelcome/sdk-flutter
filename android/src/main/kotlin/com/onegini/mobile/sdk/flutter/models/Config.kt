package com.onegini.mobile.sdk.flutter.models

data class Config(
        val configModelClassName: String?,
        val securityControllerClassName: String?,
        val httpConnectionTimeout: Int?,
        val httpReadTimeout: Int?,
        val customIdentityProviderConfigs: ArrayList<CustomIdentityProviderConfig>
)
