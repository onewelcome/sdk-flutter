package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ID_TOKEN_NOT_AVAILABLE
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetIdTokenUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<String> {
    oneginiSDK.oneginiClient.userClient.idToken?.let { idtoken ->
      return Result.success(idtoken)
    }
    return Result.failure(SdkError(ID_TOKEN_NOT_AVAILABLE).pigeonError())
  }
}