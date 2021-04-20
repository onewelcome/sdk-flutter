package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile


class RegistrationUseCase {
    operator fun invoke(oneginiClient: OneginiClient, identityProvider: OneginiIdentityProvider?, scopes: Array<String>, onFinished: (userProfileId: String?, error: OneginiRegistrationError?) -> Unit) {
        oneginiClient.userClient.registerUser(identityProvider, scopes, object : OneginiRegistrationHandler {
            override fun onSuccess(userProfile: UserProfile, customInfo: CustomInfo?) {
                onFinished(userProfile.profileId,null)
                //result.success(userProfile.profileId)
            }

            override fun onError(oneginiRegistrationError: OneginiRegistrationError) {
                onFinished(null,oneginiRegistrationError)
               // result.error(oneginiRegistrationError.errorType.toString(), oneginiRegistrationError.message, null)
            }
        })
    }
}


