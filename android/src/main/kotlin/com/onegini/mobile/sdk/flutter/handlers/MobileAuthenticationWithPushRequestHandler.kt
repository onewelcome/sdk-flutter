package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.android.handlers.request.OneginiMobileAuthWithPushRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiAcceptDenyCallback
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthenticationRequest
import com.onegini.mobile.sdk.flutter.extensions.toFlutter
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject

class MobileAuthenticationWithPushRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi):
  OneginiMobileAuthWithPushRequestHandler {

  private var mobileAuthWithPushCallback: OneginiAcceptDenyCallback? = null

  override fun startAuthentication(request: OneginiMobileAuthenticationRequest, callback: OneginiAcceptDenyCallback) {
    mobileAuthWithPushCallback = callback
    nativeApi.n2fStartMobileAuthPush(request.toFlutter()) {}
  }

  override fun finishAuthentication() {
    mobileAuthWithPushCallback = null
    nativeApi.n2fFinishMobileAuthPush {}
  }
}