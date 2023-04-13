package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.extensions.toOneginiInt
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.mapToOwCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthenticateUserUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String, authenticatorType: OWAuthenticatorType, callback: (Result<OWRegistrationResponse>) -> Unit) {
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return callback(Result.failure(error.pigeonError()))
    }

    val authenticator = oneginiSDK.oneginiClient.userClient.getRegisteredAuthenticators(userProfile)
      .find { it.type == authenticatorType.toOneginiInt() }

    authenticate(userProfile, authenticator, callback)
  }

  private fun authenticate(
    userProfile: UserProfile,
    authenticator: OneginiAuthenticator?,
    callback: (Result<OWRegistrationResponse>) -> Unit
  ) {
    if (authenticator == null) {
      oneginiSDK.oneginiClient.userClient.authenticateUser(userProfile, getOneginiAuthenticationHandler(callback))
    } else {
      oneginiSDK.oneginiClient.userClient.authenticateUser(userProfile, authenticator, getOneginiAuthenticationHandler(callback))
    }
  }

  private fun getOneginiAuthenticationHandler(callback: (Result<OWRegistrationResponse>) -> Unit): OneginiAuthenticationHandler {
    return object : OneginiAuthenticationHandler {
      override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
        val owProfile = OWUserProfile(userProfile.profileId)

        when (customInfo) {
          null -> callback(Result.success(OWRegistrationResponse(owProfile)))
          else -> {
            callback(Result.success(OWRegistrationResponse(owProfile, customInfo.mapToOwCustomInfo())))
          }
        }
      }

      override fun onError(error: OneginiAuthenticationError) {
        callback(
          Result.failure(
            SdkError(
              code = error.errorType,
              message = error.message
            ).pigeonError()
          )
        )
      }
    }
  }
}
