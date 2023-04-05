package com.onegini.mobile.sdk.flutter.providers

import com.onegini.mobile.sdk.android.handlers.action.OneginiCustomRegistrationAction
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider

class CustomIdentityProvider(private val action: CustomRegistrationAction) : OneginiCustomIdentityProvider {
  override fun getRegistrationAction(): OneginiCustomRegistrationAction {
    return action.getCustomRegistrationAction()
  }

  override fun getId(): String {
    return action.getIdProvider()
  }
}
