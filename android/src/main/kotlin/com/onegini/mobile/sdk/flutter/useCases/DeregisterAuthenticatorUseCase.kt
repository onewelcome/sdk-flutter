package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorDeregistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorDeregistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.AUTHENTICATOR_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.METHOD_ARGUMENT_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.oneginiError
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DeregisterAuthenticatorUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
    val authenticatorId = call.argument<String>("authenticatorId")
      ?: return result.wrapperError(METHOD_ARGUMENT_NOT_FOUND)

    val userProfile = oneginiSDK.oneginiClient.userClient.authenticatedUserProfile
      ?: return result.wrapperError(NO_USER_PROFILE_IS_AUTHENTICATED)

    val authenticator = getAuthenticatorById(authenticatorId, userProfile)
      ?: return result.wrapperError(AUTHENTICATOR_NOT_FOUND)

    oneginiSDK.oneginiClient.userClient.deregisterAuthenticator(authenticator, object : OneginiAuthenticatorDeregistrationHandler {
      override fun onSuccess() {
        result.success(true)
      }

      override fun onError(error: OneginiAuthenticatorDeregistrationError) {
        result.oneginiError(error)
      }
    }
    )
  }

  private fun getAuthenticatorById(authenticatorId: String?, userProfile: UserProfile): OneginiAuthenticator? {
    var authenticator: OneginiAuthenticator? = null
    val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
    for (registeredAuthenticator in registeredAuthenticators) {
      if (registeredAuthenticator.id == authenticatorId) {
        authenticator = registeredAuthenticator
      }
    }
    return authenticator
  }

}
