package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DeregisterUserUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
    val profileId = call.argument<String>("profileId")
      ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)

    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return error.flutterError(result)
    }

    oneginiSDK.oneginiClient.userClient.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
      override fun onSuccess() {
        result.success(true)
      }

      override fun onError(oneginiDeregistrationError: OneginiDeregistrationError) {
        SdkError(
          code = oneginiDeregistrationError.errorType,
          message = oneginiDeregistrationError.message
        ).flutterError(result)
      }
    })
  }
}
