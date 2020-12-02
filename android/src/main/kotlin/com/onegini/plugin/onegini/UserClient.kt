package com.onegini.plugin.onegini

import com.google.gson.annotations.SerializedName
import io.reactivex.rxjava3.core.Single
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

    @SerializedName("mobile_authentication_enabled")
    val isMobileAuthenticationEnabled: Boolean = false

    val deviceFullInfo: String
        get() = (name + Constants.NEW_LINE + application + Constants.NEW_LINE + platform + Constants.NEW_LINE
                + "Mobile authentication enabled: " + isMobileAuthenticationEnabled)
}