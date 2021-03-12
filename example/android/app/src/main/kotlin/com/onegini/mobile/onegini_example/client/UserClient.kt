package com.onegini.mobile.onegini_example.client

import com.google.gson.annotations.SerializedName
import io.reactivex.Single
import retrofit2.http.GET


interface UserClient {

    @GET("devices")
    fun getDevices(): Single<DevicesResponse>


}

class DevicesResponse {
    @SerializedName("devices")
    val devices: List<Device> = ArrayList()
}

class Device() {
    @SerializedName("id")
    val id: String? = null

    @SerializedName("name")
    val name: String? = null

    @SerializedName("application")
    val application: String? = null

    @SerializedName("platform")
    val platform: String? = null

    @SerializedName("created_at")
    val createdAt: String? = null

    @SerializedName("last_login")
    val lastLogin: String? = null

    @SerializedName("mobile_authentication_enabled")
    val isMobileAuthenticationEnabled: Boolean = false

    val deviceFullInfo: String
        get() = (name + "\n" + application + "\n" + platform + "\n"
                + "Mobile authentication enabled: " + isMobileAuthenticationEnabled)
}