package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithPushRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject

class MobileAuthenticationWithPushRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi):
  OneginiMobileAuthWithPushRequestHandler {

  override fun startAuthentication(request: OneginiMobileAuthenticationRequest, callback: OneginiAcceptDenyCallback) {
    callback.acceptAuthenticationRequest()
  }

  override fun finishAuthentication() {
    // We don't need this as finish is propagated through both the deny and handle+accept calls.
  }
}