package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import android.util.Log
import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel

object AuthHelper {

    fun getRegisteredAuthenticators(context:Context,result: MethodChannel.Result){
        val gson = GsonBuilder().serializeNulls().create()
        val userProfile = OneginiSDK.getOneginiClient(context).userClient.userProfiles.first()
        val registeredAuthenticators = userProfile.let { OneginiSDK.getOneginiClient(context).userClient.getRegisteredAuthenticators(it) }
        val authenticators: ArrayList<Map<String, String>> = ArrayList()
        if (registeredAuthenticators != null)
            for (registeredAuthenticator in registeredAuthenticators) {
                val map = mutableMapOf<String, String>()
                map["id"] = registeredAuthenticator.id
                map["name"] = registeredAuthenticator.name
                authenticators.add(map)
            }
        result.success(gson.toJson(authenticators))
    }

    fun authenticateWithRegisteredAuthenticators(context: Context,registeredAuthenticatorsId : String?,result: MethodChannel.Result){
        val userProfile = OneginiSDK.getOneginiClient(context).userClient.userProfiles.first()
        if (userProfile == null) {
            result.error(ErrorHelper().userProfileIsNull.code, ErrorHelper().userProfileIsNull.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { OneginiSDK.getOneginiClient(context).userClient.getRegisteredAuthenticators(it) }
        if (registeredAuthenticators == null) {
            result.error(ErrorHelper().registeredAuthenticatorsIsNull.code, ErrorHelper().registeredAuthenticatorsIsNull.message, null)
            return
        }
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == registeredAuthenticatorsId) {
                authenticateUser(context,userProfile, registeredAuthenticator, result)
                break
            }
        }
    }

    fun authenticateUser(context:Context,userProfile: UserProfile?, authenticator: OneginiAuthenticator?, result: MethodChannel.Result){
        if (userProfile == null) {
            result.error(ErrorHelper().userProfileIsNull.code, ErrorHelper().userProfileIsNull.message, null)
            return
        }
        if (authenticator == null) {
            OneginiSDK.getOneginiClient(context).userClient.authenticateUser(userProfile, getOneginiAuthenticationHandler(result))

        } else {
            OneginiSDK.getOneginiClient(context).userClient.authenticateUser(userProfile, authenticator, getOneginiAuthenticationHandler(result))
        }
    }

    private fun getOneginiAuthenticationHandler(result: MethodChannel.Result):OneginiAuthenticationHandler{
        return object : OneginiAuthenticationHandler{
            override fun onSuccess(userProfile: UserProfile?, p1: CustomInfo?) {
                if (userProfile != null)
                    result.success(userProfile.profileId)
            }

            override fun onError(error: OneginiAuthenticationError) {
                result.error(error.errorType.toString(), error.message ?: "", null)
            }
        }
    }
}