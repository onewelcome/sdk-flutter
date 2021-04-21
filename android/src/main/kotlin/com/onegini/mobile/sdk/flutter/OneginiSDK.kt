package com.onegini.mobile.sdk.flutter


import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import java.util.concurrent.TimeUnit


class OneginiSDK : IOneginiClient {

    private var httpConnectionTimeout: Long? = 5
    private var httpReadTimeout: Long? = 25
    private var oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider> = mutableListOf()

    companion object {
        var oneginiClientConfigModel: OneginiClientConfigModel? = null
        var oneginiSecurityController: Class<*>? = null
    }

    private fun buildSDK(context: Context): OneginiClient {
        if (oneginiClientConfigModel == null) throw Exception("OneginiClientConfigModel must be not null!")
        val applicationContext = context.applicationContext
                ?: throw  Exception("Context can`t be null!")
        val registrationRequestHandler = RegistrationRequestHandler(applicationContext)
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(applicationContext)
        val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler()
        val createPinRequestHandler = PinRequestHandler()
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler()
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                .setBrowserRegistrationRequestHandler(registrationRequestHandler)
                .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler)
                .setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout
                        ?: 5).toInt())
                .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout ?: 25).toInt())
                .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)
                .setSecurityController(oneginiSecurityController)
                .setConfigModel(oneginiClientConfigModel)
        oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
        return clientBuilder.build()
    }

    override fun getOneginiClient(context: Context): OneginiClient {
        var oneginiClient = OneginiClient.getInstance()
        if (oneginiClient == null) {
            oneginiClient = buildSDK(context)
        }
        return oneginiClient
    }

    override fun initSDK(context: Context, httpConnectionTimeout: Long?, httpReadTimeout: Long?, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>): OneginiClient {
        this.httpConnectionTimeout = httpConnectionTimeout
        this.httpReadTimeout = httpReadTimeout
        this.oneginiCustomIdentityProviders = oneginiCustomIdentityProviders
        return buildSDK(context)
    }
}