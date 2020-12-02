package com.onegini.plugin.onegini

import com.google.gson.annotations.SerializedName
import io.reactivex.rxjava3.core.Single
import retrofit2.http.GET


interface ImplicitUserClient {

    @GET("user-id-decorated")
    fun getImplicitUserDetails() : Single<ImplicitUserDetails>
}

class ImplicitUserDetails {
    @SerializedName("decorated_user_id")
    private val decoratedUserId: String? = null
    override fun toString(): String {
        return decoratedUserId!!
    }
}