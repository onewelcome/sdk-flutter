package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticateUserUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(call: MethodCall, result: MethodChannel.Result) {
    val authenticatorId = call.argument<String>("registeredAuthenticatorId")
    val profileId = call.argument<String>("profileId")
      ?: return SdkError(METHOD_ARGUMENT_NOT_FOUND).flutterError(result)

    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return error.flutterError(result)
    }

    val authenticator = getRegisteredAuthenticatorById(authenticatorId, userProfile)

    when {
      authenticatorId != null && authenticator == null -> SdkError(AUTHENTICATOR_NOT_FOUND).flutterError(result)
      else -> authenticate(userProfile, authenticator, result)
    }
  }

  private fun getRegisteredAuthenticatorById(registeredAuthenticatorsId: String?, userProfile: UserProfile): OneginiAuthenticator? {
    if (registeredAuthenticatorsId == null) return null
    val registeredAuthenticators = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
    for (registeredAuthenticator in registeredAuthenticators) {
      if (registeredAuthenticator.id == registeredAuthenticatorsId) {
        return registeredAuthenticator
      }
    }
    return null
  }

  private fun authenticate(userProfile: UserProfile, authenticator: OneginiAuthenticator?, result: MethodChannel.Result) {
    if (authenticator == null) {
      oneginiSDK.oneginiClient.userClient.authenticateUser(userProfile, getOneginiAuthenticationHandler(result))
    } else {
      oneginiSDK.oneginiClient.userClient.authenticateUser(userProfile, authenticator, getOneginiAuthenticationHandler(result))
    }
  }

  private fun getOneginiAuthenticationHandler(result: MethodChannel.Result): OneginiAuthenticationHandler {
    return object : OneginiAuthenticationHandler {
      override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
        //todo check unit tests
        val userProfileJson = mapOf("profileId" to userProfile.profileId, "isDefault" to userProfile.isDefault)
        val customInfoJson = mapOf("data" to customInfo?.data, "status" to customInfo?.status)
        val returnedResult = Gson().toJson(mapOf("userProfile" to userProfileJson, "customInfo" to customInfoJson))
        result.success(returnedResult)
      }

      override fun onError(error: OneginiAuthenticationError) {
        SdkError(
          code = error.errorType,
          message = error.message
        ).flutterError(result)
      }
    }
  }
}
