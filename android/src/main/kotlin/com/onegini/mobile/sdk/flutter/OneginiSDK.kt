package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.handlers.*
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.models.CustomIdentityProviderConfig
import com.onegini.mobile.sdk.flutter.providers.CustomIdentityProvider
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationActionImpl
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationActionImpl
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class OneginiSDK @Inject constructor(
    private val applicationContext: Context,
    private val browserRegistrationRequestHandler: BrowserRegistrationRequestHandler,
    private val fingerprintRequestHandler: FingerprintAuthenticationRequestHandler,
    private val pinAuthenticationRequestHandler: PinAuthenticationRequestHandler,
    private val createPinRequestHandler: PinRequestHandler,
    private val mobileAuthWithOtpRequestHandler: MobileAuthOtpRequestHandler,
){

    val oneginiClient: OneginiClient
        get() = OneginiClient.getInstance()?.let {client ->
                return client
            } ?: throw FlutterPluginException(ONEWELCOME_SDK_NOT_INITIALIZED)

    private var customRegistrationActions = ArrayList<CustomRegistrationAction>()

    fun buildSDK(config: Config, result: MethodChannel.Result) {
        val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                .setBrowserRegistrationRequestHandler(browserRegistrationRequestHandler)
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

        clientBuilder.build()
    }

    fun getCustomRegistrationActions(): ArrayList<CustomRegistrationAction> {
        return customRegistrationActions
    }

    private fun initProviders(clientBuilder: OneginiClientBuilder, customIdentityProviderConfigs: List<CustomIdentityProviderConfig>) {
        customIdentityProviderConfigs.forEach {
            val action = when (it.isTwoStep) {
                true -> CustomTwoStepRegistrationActionImpl(it.providerId)
                false -> CustomRegistrationActionImpl(it.providerId)
            }

            customRegistrationActions.add(action)
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
