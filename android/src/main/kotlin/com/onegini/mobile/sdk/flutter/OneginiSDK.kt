package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.models.Config
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*

class OneginiSDK {

    private var oneginiClient: OneginiClient? = null

    fun buildSDK(context: Context, oneginiCustomIdentityProviders: List<OneginiCustomIdentityProvider>, config: Config, result: MethodChannel.Result) {
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

    fun getOneginiClient(): OneginiClient? {
        return oneginiClient
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
            e.message?.let { message ->
                SdkError(
                    code = CONFIG_ERROR.code,
                    message = message
                ).flutterError(result)
            } ?: SdkError(CONFIG_ERROR).flutterError(result)
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
            e.message?.let { message ->
                SdkError(
                    code = SECURITY_CONTROLLER_NOT_FOUND.code,
                    message = message
                ).flutterError(result)
            } ?: SdkError(SECURITY_CONTROLLER_NOT_FOUND).flutterError(result)
        }
    }
}
