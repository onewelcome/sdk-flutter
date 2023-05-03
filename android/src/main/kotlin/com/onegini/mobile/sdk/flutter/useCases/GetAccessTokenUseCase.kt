package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_AUTHENTICATED_USER
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetAccessTokenUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<String> {
    oneginiSDK.oneginiClient.userClient.accessToken?.let { token ->
      return Result.success(token)
    }

    return Result.failure(SdkError(NOT_AUTHENTICATED_USER).pigeonError())
  }
}
