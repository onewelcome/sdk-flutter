package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiDeregisterUserProfileHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiDeregistrationError
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.METHOD_ARGUMENT_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import com.onegini.mobile.sdk.flutter.errors.oneginiError
import com.onegini.mobile.sdk.flutter.errors.wrapperError
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
      ?: return result.wrapperError(METHOD_ARGUMENT_NOT_FOUND)

    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: FlutterPluginException) {
      return result.wrapperError(error)
    }

    oneginiSDK.oneginiClient.userClient.deregisterUser(userProfile, object : OneginiDeregisterUserProfileHandler {
      override fun onSuccess() {
        result.success(true)
      }

      override fun onError(error: OneginiDeregistrationError) {
        result.oneginiError(error)
      }
    })
  }
}
