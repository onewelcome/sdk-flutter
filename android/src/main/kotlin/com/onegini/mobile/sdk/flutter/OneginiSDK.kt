package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import java.util.concurrent.TimeUnit

class OneginiSDK {

    private lateinit var oneginiClient: OneginiClient

    companion object {
        var oneginiClientConfigModel: OneginiClientConfigModel? = null
        var oneginiSecurityController: Class<*>? = null
        lateinit var registrationRequestHandler: RegistrationRequestHandler
    }

    fun buildSDK(context: Context, httpConnectionTimeout: Long?, httpReadTimeout: Long?, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>, oneginiEventsSender: OneginiEventsSender) {
        val applicationContext = context.applicationContext
        registrationRequestHandler = RegistrationRequestHandler(oneginiEventsSender)
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(oneginiEventsSender)
        val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler(oneginiEventsSender)
        val createPinRequestHandler = PinRequestHandler(oneginiEventsSender)
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler(oneginiEventsSender)
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
        oneginiClient = clientBuilder.build()
    }

    fun getOneginiClient(): OneginiClient {
        // todo should we use OneginiClient.getInstance or this var 
        return OneginiClient.getInstance() ?: oneginiClient
    }
    
    fun getRegistrationRequestHandler() : RegistrationRequestHandler {
        return  registrationRequestHandler
    }
}
