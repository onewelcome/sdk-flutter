package com.onegini.mobile.sdk.flutter.models

import androidx.annotation.Keep

@Keep
data class CustomTwoStepRegistrationModel(val data: String, val statusCode: Int?,val providerId: String)
