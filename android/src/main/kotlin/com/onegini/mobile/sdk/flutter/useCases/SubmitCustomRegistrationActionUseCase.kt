package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ACTION_NOT_ALLOWED_CUSTOM_REGISTRATION_SUBMIT
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class SubmitCustomRegistrationActionUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(data: String?): Result<Unit> {
    return when (val action = oneginiSDK.getCustomRegistrationActions().find { it.isInProgress() }) {
      null -> Result.failure(SdkError(ACTION_NOT_ALLOWED_CUSTOM_REGISTRATION_SUBMIT).pigeonError())
      else -> action.returnSuccess(data)
    }
  }
}
