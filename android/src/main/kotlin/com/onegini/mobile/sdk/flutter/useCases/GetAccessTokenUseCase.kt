package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NO_USER_PROFILE_IS_AUTHENTICATED
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

    return Result.failure(SdkError(NO_USER_PROFILE_IS_AUTHENTICATED))
  }
}
