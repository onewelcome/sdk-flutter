package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel

object FingerprintHelper {

    fun isUserNotRegisteredFingerprint (context: Context,result: MethodChannel.Result)  {
        val authenticator = getNotRegisteredFingerprint(context)
        if (authenticator != null) {
            result.success(true)
        } else result.success(false)
    }

    private fun getNotRegisteredFingerprint(context:Context): OneginiAuthenticator? {
        var fingerprintAuthenticator: OneginiAuthenticator? = null
        val authenticatedUserProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile ?: return null
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK.getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.type == OneginiAuthenticator.FINGERPRINT) {
                    // the fingerprint authenticator is available for registration
                    fingerprintAuthenticator = auth
                }
            }
        }
        return fingerprintAuthenticator
    }

    fun registerFingerprint(context: Context,result: MethodChannel.Result) {
        val authenticatedUserProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile
        if (authenticatedUserProfile == null) {
            result.error(ErrorHelper().authenticatedUserProfileIsNull.code, ErrorHelper().authenticatedUserProfileIsNull.message, null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK.getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.type == OneginiAuthenticator.FINGERPRINT) {
                    // the fingerprint authenticator is available for registration
                   AuthenticatorsHelper.registerAuthenticator(context,auth.id,result)
                }
            }
        }
    }

}