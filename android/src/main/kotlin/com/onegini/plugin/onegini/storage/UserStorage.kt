package com.onegini.plugin.onegini.storage

import android.content.Context
import android.content.SharedPreferences
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.model.User


class UserStorage(context: Context) {
    private val sharedPreferences: SharedPreferences
    fun saveUser(user: User) {
        val editor = sharedPreferences.edit()
        editor.putString(user.userProfile.profileId, user.name)
        editor.apply()
    }

    fun loadUser(userProfile: UserProfile): User {
        return User(userProfile, sharedPreferences.getString(userProfile.profileId, EMPTY) ?: "")
    }

    fun removeUser(userProfile: UserProfile) {
        val editor = sharedPreferences.edit()
        editor.remove(userProfile.profileId)
        editor.apply()
    }

    fun loadUsers(userProfiles: Set<UserProfile>): List<User> {
        val listOfUsers: MutableList<User> = ArrayList(userProfiles.size)
        for (userProfile in userProfiles) {
            listOfUsers.add(loadUser(userProfile))
        }
        return listOfUsers
    }

    fun clearStorage() {
        sharedPreferences.edit().clear().apply()
    }

    companion object {
        private const val PREFS_NAME = "user_storage"
        private const val EMPTY = ""
    }

    init {
        sharedPreferences = context.getSharedPreferences(PREFS_NAME, 0)
    }
}
