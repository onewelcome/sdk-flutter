package com.onegini.plugin.onegini.helpers

import android.content.Context
import android.net.Uri
import androidx.annotation.Nullable
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.handlers.RegistrationRequestHandler


class RegistrationHelper {
    companion object {
        
        fun registerUser(packageContext: Context, @Nullable identityProvider: OneginiIdentityProvider?, scopes: Array<String>,registrationHandler: OneginiRegistrationHandler) {
            val oneginiClient: OneginiClient? = OneginiSDK.getOneginiClient(packageContext)
            oneginiClient?.userClient?.registerUser(identityProvider, scopes, registrationHandler)
        }

        fun handleRegistrationCallback(uri: Uri?) {
            RegistrationRequestHandler.handleRegistrationCallback(uri)
        }

        fun cancelRegistration() {
            RegistrationRequestHandler.onRegistrationCanceled()
        }
    }
}
