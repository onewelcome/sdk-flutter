package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiStatelessRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_FOUND_IDENTITY_PROVIDER
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.mapToOwCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class StatelessRegistrationUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(identityProviderId: String?, scopes: List<String>?, callback: (Result<OWRegistrationResponse>) -> Unit) {
    val identityProvider = oneginiSDK.oneginiClient.userClient.identityProviders.find { it.id == identityProviderId }

    if (identityProviderId != null && identityProvider == null) {
      callback(Result.failure(SdkError(NOT_FOUND_IDENTITY_PROVIDER).pigeonError()))
      return
    }

    val registerScopes = scopes?.toTypedArray()

    registerStateless(identityProvider, registerScopes, callback)
  }

  private fun registerStateless(
    identityProvider: OneginiIdentityProvider?,
    scopes: Array<String>?,
    callback: (Result<OWRegistrationResponse>) -> Unit
  ) {
    oneginiSDK.oneginiClient.userClient.registerStatelessUser(identityProvider, scopes, object : OneginiStatelessRegistrationHandler {
      override fun onSuccess(customInfo: CustomInfo?) {
        val user = OWUserProfile("stateless")

        when (customInfo) {
          null -> callback(Result.success(OWRegistrationResponse(user)))
          else -> {
            callback(Result.success(OWRegistrationResponse(user, customInfo.mapToOwCustomInfo())))
          }
        }
      }

      override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
        callback(
          Result.failure(
            SdkError(
              code = oneginiRegistrationError.errorType,
              message = oneginiRegistrationError.message
            ).pigeonError()
          )
        )
      }
    })
  }
}