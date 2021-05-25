package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import java.util.concurrent.TimeUnit

class OneginiSDK {

    companion object {
        var oneginiClientConfigModel: OneginiClientConfigModel? = null
        var oneginiSecurityController: Class<*>? = null
    }

    private fun buildSDK(context: Context, httpConnectionTimeout: Long?, httpReadTimeout: Long?, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>): OneginiClient {
        val applicationContext = context.applicationContext
        val registrationRequestHandler = RegistrationRequestHandler()
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(applicationContext)
        val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler()
        val createPinRequestHandler = PinRequestHandler()
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler()
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                .setBrowserRegistrationRequestHandler(registrationRequestHandler)
                .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler)
                .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)
                .setSecurityController(oneginiSecurityController)
                .setConfigModel(oneginiClientConfigModel)
        oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
        if (httpConnectionTimeout != null) {
            clientBuilder.setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout).toInt())
        }
        if (httpReadTimeout != null) {
            clientBuilder.setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout).toInt())
        }
        return clientBuilder.build()
    }

    fun getOneginiClient(context: Context, httpConnectionTimeout: Long? = null, httpReadTimeout: Long? = null, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider> = mutableListOf()): OneginiClient {
        var oneginiClient = OneginiClient.getInstance()
        if (oneginiClient == null) {
            oneginiClient = buildSDK(context, httpConnectionTimeout, httpReadTimeout, oneginiCustomIdentityProviders)
        }
        return oneginiClient
    }

}
