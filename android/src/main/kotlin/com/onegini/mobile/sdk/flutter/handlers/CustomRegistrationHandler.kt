package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction

class CustomRegistrationHandler {
  fun getCustomRegistrationAction(
    idProvider: String?,
    customRegistrationActions: ArrayList<CustomRegistrationAction>
  ): CustomRegistrationAction? {
    return idProvider?.let { customRegistrationActions.find { it.getIdProvider() == idProvider } }
  }
}
