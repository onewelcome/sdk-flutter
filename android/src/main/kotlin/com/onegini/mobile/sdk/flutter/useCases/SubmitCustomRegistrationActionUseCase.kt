package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.IDENTITY_PROVIDER_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SubmitCustomRegistrationActionUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(identityProviderId: String, data: String?): Result<Unit> {
    return when (val action = oneginiSDK.getCustomRegistrationActions().find { it.getIdProvider() == identityProviderId }) {
      null -> Result.failure(SdkError(IDENTITY_PROVIDER_NOT_FOUND).pigeonError())
      else -> {
        action.returnSuccess(data)
      }
    }
  }
}
