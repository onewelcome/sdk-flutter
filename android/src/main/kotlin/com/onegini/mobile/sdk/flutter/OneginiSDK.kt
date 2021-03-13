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

        fun init(context: Context,
                 oneginiConfigModel: OneginiClientConfigModel,
                 securityController: Class<*>? = null,
                 connectionTimeout: Long = 5,
                 readTimeout: Long = 25,
                 oneginiCustomIdentityProviders: MutableList<OneginiCustomIdentityProvider>
                 = mutableListOf()) {
            val oneginiSDK = OneginiSDK()
            oneginiSDK.httpConnectionTimeout = connectionTimeout
            oneginiSDK.httpReadTimeout = readTimeout
            oneginiSDK.oneginiClientConfigModel = oneginiConfigModel
            oneginiSDK.oneginiSecurityController = securityController
            oneginiSDK.oneginiCustomIdentityProviders = oneginiCustomIdentityProviders
            oneginiSDK.buildSDK(context)
        }

        fun getOneginiClient(context: Context): OneginiClient {
            var oneginiClient = OneginiClient.getInstance()
            if (oneginiClient == null) {
                oneginiClient = OneginiSDK().buildSDK(context)
            }
            return oneginiClient
        }

    }

    var oneginiClientConfigModel: OneginiClientConfigModel? = null
    var oneginiSecurityController: Class<*>? = null
    var httpConnectionTimeout: Long = 5
    var httpReadTimeout: Long = 20
    var oneginiCustomIdentityProviders = mutableListOf<OneginiCustomIdentityProvider>()

    private fun buildSDK(context: Context): OneginiClient {
        if (oneginiClientConfigModel == null) throw Exception("OneginiClientConfigModel must be not null!")
        val applicationContext = context.applicationContext ?: throw  Exception ("Context can`t be null!")
        val registrationRequestHandler = RegistrationRequestHandler(applicationContext)
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(applicationContext)
        val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler()
        val createPinRequestHandler = PinRequestHandler()
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler()
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                .setBrowserRegistrationRequestHandler(registrationRequestHandler)
                .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler)
                .setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout).toInt())
                .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout).toInt())
                .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)
                .setSecurityController(oneginiSecurityController)
                .setConfigModel(oneginiClientConfigModel)
        oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
        return clientBuilder.build()
    }
}