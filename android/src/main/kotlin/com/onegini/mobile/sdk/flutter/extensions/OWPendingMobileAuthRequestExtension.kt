package com.onegini.mobile.sdk.flutter.extensions

import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthWithPushRequest
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWPendingMobileAuthRequest

fun OWPendingMobileAuthRequest.toOnegini(): OneginiMobileAuthWithPushRequest {
  return OneginiMobileAuthWithPushRequest(this.transactionId, this.message, this.userProfileId, this.date, this.timeToLive.toInt())
}