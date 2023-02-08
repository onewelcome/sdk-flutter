package com.onegini.mobile.sdk.flutter.useCases

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import io.flutter.plugin.common.MethodChannel

class GetUserProfilesUseCase(private val oneginiClient: OneginiClient) {
    operator fun invoke(result: MethodChannel.Result) {
        val userProfiles = oneginiClient.userClient.userProfiles
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
