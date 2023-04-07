package com.onegini.mobile.sdk.flutter.handlers

import android.net.Uri
import com.onegini.mobile.sdk.android.handlers.request.OneginiBrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class BrowserRegistrationRequestHandler @Inject constructor(private val nativeApi: NativeCallFlutterApi) :
  OneginiBrowserRegistrationRequestHandler {
  private var callback: OneginiBrowserRegistrationCallback? = null

  fun handleRegistrationCallback(uri: Uri): Result<Unit> {
    return callback?.let {
      it.handleRegistrationCallback(uri)
      Result.success(Unit)
    } ?: Result.failure(SdkError(BROWSER_REGISTRATION_NOT_IN_PROGRESS).pigeonError())
  }

  fun cancelRegistration(): Result<Unit> {
    return callback?.let {
      it.denyRegistration()
      Result.success(Unit)
    } ?: Result.failure(SdkError(BROWSER_REGISTRATION_NOT_IN_PROGRESS).pigeonError())
  }

  override fun startRegistration(uri: Uri, oneginiBrowserRegistrationCallback: OneginiBrowserRegistrationCallback) {
    callback = oneginiBrowserRegistrationCallback
    nativeApi.n2fHandleRegisteredUrl(uri.toString()) {}
  }
}
