package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetNotRegisteredAuthenticatorsUseCase @Inject constructor(
  private val oneginiSDK: OneginiSDK,
  private val getUserProfileUseCase: GetUserProfileUseCase
) {
  operator fun invoke(profileId: String): Result<List<OWAuthenticator>> {
    val userProfile = try {
      getUserProfileUseCase(profileId)
    } catch (error: SdkError) {
      return Result.failure(error)
    }

    val notRegisteredAuthenticators = oneginiSDK.oneginiClient.userClient.getNotRegisteredAuthenticators(userProfile)
    val authenticators = mutableListOf<OWAuthenticator>()
    for (auth in notRegisteredAuthenticators) {
      val authenticator = OWAuthenticator(
        auth.id,
        auth.name,
        auth.isRegistered,
        auth.isPreferred,
        auth.type.toLong()
      )

      authenticators.add(authenticator)
    }
    return Result.success(authenticators)
  }
}
