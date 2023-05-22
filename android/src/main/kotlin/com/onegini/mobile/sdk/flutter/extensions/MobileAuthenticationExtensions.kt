package com.onegini.mobile.sdk.flutter.extensions

import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthWithPushRequest
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWMobileAuthWithPushRequest

fun OWMobileAuthWithPushRequest.toOnegini(): OneginiMobileAuthWithPushRequest {
  return OneginiMobileAuthWithPushRequest(this.transactionId, this.message, this.userProfileId, this.date ?: 0, this.timeToLive?.toInt() ?: 0)
}

fun OneginiMobileAuthWithPushRequest.toFlutter(): OWMobileAuthWithPushRequest {
  return OWMobileAuthWithPushRequest(
    transactionId = this.transactionId,
    userProfileId = this.userProfileId,
    date = this.timestamp,
    timeToLive = this.timeToLiveSeconds.toLong(),
    message = this.message,
  )
}

//fun OneginiMobileAuthenticationRequest.toFlutter(): OWMobileAuthRequest {
//  return OWMobileAuthRequest(
//    message = this.message,
//    type = this.type,
//    userProfileId = this.userProfile.profileId,
//    transactionId = this.transactionId,
//    signingData = this.signingData,
//  )
//}