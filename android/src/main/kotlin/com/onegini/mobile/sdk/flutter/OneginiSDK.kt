package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import java.util.concurrent.TimeUnit

class OneginiSDK {

    private var httpConnectionTimeout: Long? = 5
    private var httpReadTimeout: Long? = 25
    private var oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider> = mutableListOf()

    companion object {
        var oneginiClientConfigModel: OneginiClientConfigModel? = null
        var oneginiSecurityController: Class<*>? = null
    }

    private fun buildSDK(context: Context): OneginiClient {
        val applicationContext = context.applicationContext
        val registrationRequestHandler = RegistrationRequestHandler()
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(applicationContext)
        val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler()
        val createPinRequestHandler = PinRequestHandler()
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler()
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
            .setBrowserRegistrationRequestHandler(registrationRequestHandler)
            .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler)
            .setHttpConnectTimeout(
                TimeUnit.SECONDS.toMillis(
                    httpConnectionTimeout
                        ?: 5
                ).toInt()
            )
            .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout ?: 25).toInt())
            .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)
            .setSecurityController(oneginiSecurityController)
            .setConfigModel(oneginiClientConfigModel)
        oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
        return clientBuilder.build()
    }

    fun getOneginiClient(context: Context): OneginiClient {
        var oneginiClient = OneginiClient.getInstance()
        if (oneginiClient == null) {
            oneginiClient = buildSDK(context)
        }
        return oneginiClient
    }

    fun initSDK(context: Context, httpConnectionTimeout: Long?, httpReadTimeout: Long?, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>): OneginiClient {
        this.httpConnectionTimeout = httpConnectionTimeout
        this.httpReadTimeout = httpReadTimeout
        this.oneginiCustomIdentityProviders = oneginiCustomIdentityProviders
        return buildSDK(context)
    }
}
