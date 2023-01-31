package com.onegini.mobile.sdk.flutter.models

import androidx.annotation.Keep

@Keep
data class CustomRegistrationModel(val data: String, val status: Int?, val providerId: String)
