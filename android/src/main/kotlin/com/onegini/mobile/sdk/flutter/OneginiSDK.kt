package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.Config
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class OneginiSDK {

    private lateinit var registrationRequestHandler: RegistrationRequestHandler
    private var fingerprintRequestHandler: FingerprintAuthenticationRequestHandler? = null
    private var pinAuthenticationRequestHandler: PinAuthenticationRequestHandler? = null
    private var oneginiClient: OneginiClient? = null

    fun buildSDK(context: Context, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>, config: Config, oneginiEventsSender: OneginiEventsSender, result: MethodChannel.Result) {
        val applicationContext = context.applicationContext
        registrationRequestHandler = RegistrationRequestHandler(oneginiEventsSender)
        fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(oneginiEventsSender)
        pinAuthenticationRequestHandler = PinAuthenticationRequestHandler(oneginiEventsSender)
        val fingerprintRequestHandler = FingerprintAuthenticationRequestHandler(oneginiEventsSender)
        val createPinRequestHandler = PinRequestHandler(oneginiEventsSender)
        val mobileAuthWithOtpRequestHandler = MobileAuthOtpRequestHandler(oneginiEventsSender)
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler!!) // handlers for optional functionalities
            .setBrowserRegistrationRequestHandler(registrationRequestHandler)
            .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler!!)
            .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)

        oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }

        val httpConnectionTimeout = config.httpConnectionTimeout
        val httpReadTimeout = config.httpReadTimeout

        if (httpConnectionTimeout != null) {
            clientBuilder.setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout).toInt())
        }

        if (httpReadTimeout != null) {
            clientBuilder.setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout).toInt())
        }

        setConfigModel(clientBuilder, config, result)

        setSecurityController(clientBuilder, config, result)

        oneginiClient = clientBuilder.build()
    }

    fun getRegistrationRequestHandler(): RegistrationRequestHandler {
        return registrationRequestHandler
    }

    fun getOneginiClient(): OneginiClient? {
        return oneginiClient
    }

    fun getPinAuthenticationRequestHandler() : PinAuthenticationRequestHandler? {
        return pinAuthenticationRequestHandler
    }

    fun getFingerprintAuthenticationRequestHandler() : FingerprintAuthenticationRequestHandler? {
        return fingerprintRequestHandler
    }

    private fun setConfigModel(clientBuilder: OneginiClientBuilder, config: Config) {
    private fun setConfigModel(clientBuilder: OneginiClientBuilder, config: Config, result: MethodChannel.Result) {
        if (config.configModelClassName == null) {
            return
        }
        try {
            val clazz = Class.forName(config.configModelClassName)
            val ctor = clazz.getConstructor()
            val `object` = ctor.newInstance()
            if (`object` is OneginiClientConfigModel) {
                clientBuilder.setConfigModel(`object`)
            }
        } catch (e: Exception) {
            result.error("10000", e.message, null)
        }
    }

    private fun setSecurityController(clientBuilder: OneginiClientBuilder, config: Config, result: MethodChannel.Result) {
        if (config.securityControllerClassName == null) {
            return
        }
        try {
            val securityController = Class.forName(config.securityControllerClassName)
            clientBuilder.setSecurityController(securityController)
        } catch (e: ClassNotFoundException) {
            result.error("10000", e.message, null)
        }
    }
}
