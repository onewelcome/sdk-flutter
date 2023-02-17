package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import io.flutter.plugin.common.MethodChannel
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class GetUserProfilesUseCase @Inject constructor (private val oneginiSDK: OneginiSDK) {
    operator fun invoke(result: MethodChannel.Result) {
        val userProfiles = oneginiSDK.oneginiClient.userClient.userProfiles
        val userProfileArray = getUserProfileArray(userProfiles)
        result.success(Gson().toJson(userProfileArray))
    }

    private fun getUserProfileArray(userProfiles: Set<UserProfile?>?): ArrayList<Map<String, Any>> {
        val userProfileArray: ArrayList<Map<String, Any>> = ArrayList()
        if (userProfiles != null) {
            for (userProfile in userProfiles) {
                if (userProfile != null && userProfile.profileId != null) {
                    val map = mutableMapOf<String, Any>()
                    map["isDefault"] = userProfile.isDefault
                    map["profileId"] = userProfile.profileId
                    userProfileArray.add(map)
                }
            }
        }
        return userProfileArray
    }
}
