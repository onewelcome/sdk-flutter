package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel

object AuthenticatorsHelper {

    fun getNotRegisteredAuthenticators(context: Context,result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val authenticatedUserProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile
        if(authenticatedUserProfile == null){
            result.error(ErrorHelper().authenticatedUserProfileIsNull.code,ErrorHelper().authenticatedUserProfileIsNull.message,null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK.getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = auth.id
                map["name"] = auth.name
                authenticators.add(map)
            }
        }
        result.success(gson.toJson(authenticators))
    }


    fun registerAuthenticator(context: Context,authenticatorId: String?,result: MethodChannel.Result){
        var authenticator: OneginiAuthenticator? = null
        val authenticatedUserProfile = OneginiSDK.getOneginiClient(context).userClient.authenticatedUserProfile
        if(authenticatedUserProfile == null){
            result.error(ErrorHelper().authenticatedUserProfileIsNull.code,ErrorHelper().authenticatedUserProfileIsNull.message,null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK.getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.id == authenticatorId) {
                    authenticator = auth
                }
            }
        }
        if (authenticator == null) {
            result.error(ErrorHelper().authenticatorIsNull.code, ErrorHelper().authenticatorIsNull.message, null)
            return
        }
        OneginiSDK.getOneginiClient(context).userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                result.success(customInfo?.data)
            }

            override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                result.error(oneginiAuthenticatorRegistrationError.errorType.toString(), oneginiAuthenticatorRegistrationError.message, null)
            }
        })
    }

}