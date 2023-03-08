package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetIdentityProvidersUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(): Result<List<OWIdentityProvider>> {
    val identityProviders = oneginiSDK.oneginiClient.userClient.identityProviders
    val providers: MutableList<OWIdentityProvider> = mutableListOf()

    for (identityProvider in identityProviders) {
      providers.add(OWIdentityProvider(identityProvider.id, identityProvider.name))
    }

    return Result.success(providers)
  }
}
