package com.onegini.plugin.onegini

import com.google.gson.annotations.SerializedName
import io.reactivex.rxjava3.core.Single;
import retrofit2.http.GET;

interface AnonymousClient {
    @GET("application-details")
    fun getApplicationDetails(): Single<ApplicationDetails>
}

class ApplicationDetails {
    @SerializedName("application_identifier")
    val applicationIdentifier: String? = null

    @SerializedName("application_platform")
    val applicationPlatform: String? = null

    @SerializedName("application_version")
    val applicationVersion: String? = null
}