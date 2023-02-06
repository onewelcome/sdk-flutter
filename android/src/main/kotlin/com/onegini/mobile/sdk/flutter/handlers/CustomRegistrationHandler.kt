package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction

class CustomRegistrationHandler {
  fun getCustomRegistrationAction(
    idProvider: String?,
    customRegistrationActions: ArrayList<CustomRegistrationAction>
  ): CustomRegistrationAction? {
    if (idProvider == null) return null

    return customRegistrationActions.find { it.getIdProvider() == idProvider }
  }
}
