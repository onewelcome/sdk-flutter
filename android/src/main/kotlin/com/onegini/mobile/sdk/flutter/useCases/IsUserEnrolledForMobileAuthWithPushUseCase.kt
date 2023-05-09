package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import javax.inject.Inject

class IsUserEnrolledForMobileAuthWithPushUseCase @Inject constructor(private val oneginiSDK: OneginiSDK, private val getUserProfileUseCase: GetUserProfileUseCase) {
  operator fun invoke(profileId: String): Result<Unit> {
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return Result.failure(error.pigeonError())
    }
    return if (oneginiSDK.oneginiClient.userClient.isUserEnrolledForMobileAuthWithPush(userProfile)) {
      Result.success(Unit)
    } else {
      Result.failure(SdkError(NOT_ENROLLED_FOR_MOBILE_AUTH_WITH_PUSH).pigeonError())
    }
  }
}
