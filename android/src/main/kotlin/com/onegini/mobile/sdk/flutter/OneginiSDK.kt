package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.OneginiEventsSender
import com.onegini.mobile.sdk.flutter.models.Config
import java.lang.reflect.InvocationTargetException
import java.util.concurrent.TimeUnit

class OneginiSDK {

    private lateinit var oneginiClient: OneginiClient
    private lateinit var registrationRequestHandler: RegistrationRequestHandler
    
    fun buildSDK(context: Context, httpConnectionTimeout: Long?, httpReadTimeout: Long?, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>, config: Config, oneginiEventsSender: OneginiEventsSender) {
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

        // Set config model
        setConfigModel(clientBuilder, config)

        // Set security controller
        setSecurityController(clientBuilder, config)
        
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

    private fun setConfigModel(clientBuilder: OneginiClientBuilder, config: Config) {
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
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
        } catch (e: NoSuchMethodException) {
            e.printStackTrace()
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        } catch (e: InstantiationException) {
            e.printStackTrace()
        } catch (e: InvocationTargetException) {
            e.printStackTrace()
        }
    }

    private fun setSecurityController(clientBuilder: OneginiClientBuilder, config: Config) {
        if (config.securityControllerClassName == null) {
            return
        }
        try {
            val securityController = Class.forName(config.securityControllerClassName)
            clientBuilder.setSecurityController(securityController)
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
        }
    }
}
