package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.models.CustomIdentityProviderConfig
import com.onegini.mobile.sdk.flutter.providers.CustomIdentityProvider
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationActionImp
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationActionImpl
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class OneginiSDK {

    private var oneginiClient: OneginiClient? = null
    private var customRegistrationActions = ArrayList<CustomRegistrationAction>()

    fun buildSDK(context: Context, config: Config, result: MethodChannel.Result) {
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

        initProviders(clientBuilder, config.customIdentityProviderConfigs)

        val httpConnectionTimeout = config.httpConnectionTimeout
        val httpReadTimeout = config.httpReadTimeout

        if (httpConnectionTimeout != null) {
            clientBuilder.setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout.toLong()).toInt())
        }

        if (httpReadTimeout != null) {
            clientBuilder.setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout.toLong()).toInt())
        }

        setConfigModel(clientBuilder, config, result)

        setSecurityController(clientBuilder, config, result)

        oneginiClient = clientBuilder.build()
    }

    fun getOneginiClient(): OneginiClient? {
        return oneginiClient
    }

    fun getCustomRegistrationActions(): ArrayList<CustomRegistrationAction> {
        return customRegistrationActions
    }

    private fun initProviders(clientBuilder: OneginiClientBuilder, customIdentityProviderConfigs: List<CustomIdentityProviderConfig>) {
        customIdentityProviderConfigs.forEach {
            val action = when (it.isTwoStep) {
                true -> CustomTwoStepRegistrationActionImpl(it.providerID)
                false -> CustomRegistrationActionImp(it.providerID)
            }

            // Save action for future custom registration steps
            customRegistrationActions.add(action)

            // set provider in the client builder
            clientBuilder.addCustomIdentityProvider(CustomIdentityProvider(action))
        }
    }

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
           result.error("10000",e.message, null)
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
            result.error("10000",e.message, null)
        }
    }
}
