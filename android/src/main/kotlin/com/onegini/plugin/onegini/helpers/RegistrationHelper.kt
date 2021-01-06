package com.onegini.plugin.onegini.helpers

import android.content.Context
import android.net.Uri
import androidx.annotation.Nullable
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError.RegistrationErrorType
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.constants.Constants
import com.onegini.plugin.onegini.handlers.RegistrationRequestHandler


class RegistrationHelper {
    companion object {
        fun getRedirectUri(packageContext: Context): String? {
            val client: OneginiClient? = OneginiSDK.getOneginiClient(packageContext.applicationContext)
            return client?.configModel?.redirectUri
        }

        fun registerUser(packageContext: Context, @Nullable identityProvider: OneginiIdentityProvider?, scopes: Array<String>,registrationHandler: OneginiRegistrationHandler) {
            val oneginiClient: OneginiClient? = OneginiSDK.getOneginiClient(packageContext)
            oneginiClient?.userClient?.registerUser(identityProvider, scopes, registrationHandler)
        }

        @Nullable
        fun getErrorMessageByCode(@RegistrationErrorType errorType: Int): String? {
            return when (errorType) {
                OneginiRegistrationError.DEVICE_DEREGISTERED -> "The device was deregistered, please try registering again"
                OneginiRegistrationError.ACTION_CANCELED -> "Registration was cancelled"
                OneginiAuthenticationError.NETWORK_CONNECTIVITY_PROBLEM -> "No internet connection."
                OneginiAuthenticationError.SERVER_NOT_REACHABLE -> "The server is not reachable."
                OneginiRegistrationError.OUTDATED_APP -> "Please update this application in order to use it."
                OneginiRegistrationError.OUTDATED_OS -> "Please update your Android version to use this application."
                OneginiRegistrationError.INVALID_IDENTITY_PROVIDER -> "The Identity provider you were trying to use is invalid."
                OneginiRegistrationError.CUSTOM_REGISTRATION_EXPIRED -> "Custom registration request has expired. Please retry."
                OneginiRegistrationError.CUSTOM_REGISTRATION_FAILURE -> "Custom registration request has failed, see logcat for more details."
                OneginiRegistrationError.GENERAL_ERROR -> "General error"
                else -> null
            }
        }

        fun handleRegistrationCallback(uri: Uri?) {
            RegistrationRequestHandler.handleRegistrationCallback(uri)
        }

        fun cancelRegistration() {
            RegistrationRequestHandler.onRegistrationCanceled()
        }
    }
}
