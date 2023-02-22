package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiImplicitAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiImplicitTokenRequestError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.METHOD_ARGUMENT_NOT_FOUND
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticateUserImplicitlyUseCase @Inject constructor(private val oneginiSDK: OneginiSDK,
                                                            private val getUserProfileUseCase: GetUserProfileUseCase) {
  operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
    val profileId = call.argument<String>("profileId")
      ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)
    val scopes = call.argument<ArrayList<String>>("scopes")

    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return error.flutterError(result)
    }

    oneginiSDK.oneginiClient.userClient.authenticateUserImplicitly(
      userProfile,
      scopes?.toTypedArray(),
      object : OneginiImplicitAuthenticationHandler {
        override fun onSuccess(profile: UserProfile) {
          result.success(userProfile.profileId)
        }

        override fun onError(error: OneginiImplicitTokenRequestError) {
          SdkError(
            code = error.errorType,
            message = error.message
          ).flutterError(result)
        }
      }
    )
  }
}
