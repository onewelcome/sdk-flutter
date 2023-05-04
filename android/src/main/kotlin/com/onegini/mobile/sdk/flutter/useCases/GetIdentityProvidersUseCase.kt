package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetIdentityProvidersUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<List<OWIdentityProvider>> {
    return  oneginiSDK.oneginiClient.userClient.identityProviders
      .map { OWIdentityProvider(it.id, it.name) }
      .let { Result.success(it) }
  }
}
