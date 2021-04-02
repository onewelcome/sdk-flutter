package com.onegini.mobile.sdk.flutter.helpers

import android.content.Context
import com.google.gson.GsonBuilder
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticationHandler
import com.onegini.mobile.sdk.android.handlers.OneginiAuthenticatorRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiAuthenticatorRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import io.flutter.plugin.common.MethodChannel

object AuthenticationObject {


    fun getNotRegisteredAuthenticators(context: Context,result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val authenticatedUserProfile = OneginiSDK().getOneginiClient(context).userClient.authenticatedUserProfile
        if(authenticatedUserProfile == null){
            result.error(OneginiWrapperErrors().authenticatedUserProfileIsNull.code, OneginiWrapperErrors().authenticatedUserProfileIsNull.message,null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK().getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
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
        val authenticatedUserProfile = OneginiSDK().getOneginiClient(context).userClient.authenticatedUserProfile
        if(authenticatedUserProfile == null){
            result.error(OneginiWrapperErrors().authenticatedUserProfileIsNull.code, OneginiWrapperErrors().authenticatedUserProfileIsNull.message,null)
            return
        }
        val notRegisteredAuthenticators = authenticatedUserProfile.let { OneginiSDK().getOneginiClient(context).userClient.getNotRegisteredAuthenticators(it) }
        if (notRegisteredAuthenticators != null) {
            for (auth in notRegisteredAuthenticators) {
                if (auth.id == authenticatorId) {
                    authenticator = auth
                }
            }
        }
        if (authenticator == null) {
            result.error(OneginiWrapperErrors().authenticatorIsNull.code, OneginiWrapperErrors().authenticatorIsNull.message, null)
            return
        }
        OneginiSDK().getOneginiClient(context).userClient.registerAuthenticator(authenticator, object : OneginiAuthenticatorRegistrationHandler {
            override fun onSuccess(customInfo: CustomInfo?) {
                result.success(customInfo?.data)
            }

            override fun onError(oneginiAuthenticatorRegistrationError: OneginiAuthenticatorRegistrationError) {
                result.error(oneginiAuthenticatorRegistrationError.errorType.toString(), oneginiAuthenticatorRegistrationError.message, null)
            }
        })
    }




    fun getRegisteredAuthenticators(context: Context, result: MethodChannel.Result) {
        val gson = GsonBuilder().serializeNulls().create()
        val userProfile = OneginiSDK().getOneginiClient(context).userClient.userProfiles.first()
        val registeredAuthenticators = userProfile.let { OneginiSDK().getOneginiClient(context).userClient.getRegisteredAuthenticators(it) }
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

    fun authenticateUser(context: Context, registeredAuthenticatorsId: String?, result: MethodChannel.Result) {
        var authenticator: OneginiAuthenticator? = null
        val userProfile = OneginiSDK().getOneginiClient(context).userClient.userProfiles.first()
        if (userProfile == null) {
            result.error(OneginiWrapperErrors().userProfileIsNull.code, OneginiWrapperErrors().userProfileIsNull.message, null)
            return
        }
        val registeredAuthenticators = userProfile.let { OneginiSDK().getOneginiClient(context).userClient.getRegisteredAuthenticators(it) }
        if (registeredAuthenticators == null) {
            result.error(OneginiWrapperErrors().registeredAuthenticatorsIsNull.code, OneginiWrapperErrors().registeredAuthenticatorsIsNull.message, null)
            return
        }
        for (registeredAuthenticator in registeredAuthenticators) {
            if (registeredAuthenticator.id == registeredAuthenticatorsId) {
                authenticator = registeredAuthenticator
                break
            }
        }
        authenticate(context, userProfile, authenticator, result)
    }

    private fun authenticate(context: Context, userProfile: UserProfile, authenticator: OneginiAuthenticator?, result: MethodChannel.Result) {
        if (authenticator == null) {
            OneginiSDK().getOneginiClient(context).userClient.authenticateUser(userProfile, getOneginiAuthenticationHandler(result))

        } else {
            OneginiSDK().getOneginiClient(context).userClient.authenticateUser(userProfile, authenticator, getOneginiAuthenticationHandler(result))
        }
    }

    private fun getOneginiAuthenticationHandler(result: MethodChannel.Result): OneginiAuthenticationHandler {
        return object : OneginiAuthenticationHandler {
            override fun onSuccess(userProfile: UserProfile, p1: CustomInfo?) {
                result.success(userProfile.profileId)
            }

            override fun onError(error: OneginiAuthenticationError) {
                result.error(error.errorType.toString(), error.message, null)
            }
        }
    }
}