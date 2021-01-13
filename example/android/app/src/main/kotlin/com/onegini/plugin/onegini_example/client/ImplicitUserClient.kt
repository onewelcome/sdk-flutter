package com.onegini.plugin.onegini_example.client

import com.google.gson.annotations.SerializedName
import io.reactivex.Single
import retrofit2.http.GET


interface ImplicitUserClient {

    @GET("user-id-decorated")
    fun getImplicitUserDetails() : Single<ImplicitUserDetails>
}

class ImplicitUserDetails {
    @SerializedName("decorated_user_id")
    private val decoratedUserId: String = ""
    override fun toString(): String {
        return decoratedUserId
    }
}