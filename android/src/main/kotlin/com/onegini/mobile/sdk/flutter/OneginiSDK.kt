package com.onegini.mobile.sdk.flutter

import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.CONFIG_ERROR
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ONEWELCOME_SDK_NOT_INITIALIZED
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.NOT_FOUND_SECURITY_CONTROLLER
import com.onegini.mobile.sdk.flutter.errors.FlutterPluginException
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.FingerprintAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthOtpRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.MobileAuthenticationWithPushRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomIdentityProvider
import com.onegini.mobile.sdk.flutter.providers.CustomIdentityProvider
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationActionImpl
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepRegistrationActionImpl
import java.util.concurrent.TimeUnit
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
  private val mobileAuthenticationWithPushRequestHandler: MobileAuthenticationWithPushRequestHandler,
  private val nativeApi: NativeCallFlutterApi,
) {

  val oneginiClient: OneginiClient
    get() = OneginiClient.getInstance()?.let { client ->
      return client
    } ?: throw FlutterPluginException(ONEWELCOME_SDK_NOT_INITIALIZED)

  private var customRegistrationActions = ArrayList<CustomRegistrationAction>()

  fun buildSDK(
    securityControllerClassName: String?,
    configModelClassName: String?,
    customIdentityProviderConfigs: List<OWCustomIdentityProvider>?,
    connectionTimeout: Long?,
    readTimeout: Long?
  ) {
    val clientBuilder = OneginiClientBuilder(
      applicationContext,
      createPinRequestHandler,
      pinAuthenticationRequestHandler
    ) // handlers for optional functionalities
      .setBrowserRegistrationRequestHandler(browserRegistrationRequestHandler)
      .setFingerprintAuthenticationRequestHandler(fingerprintRequestHandler)
      .setMobileAuthWithOtpRequestHandler(mobileAuthWithOtpRequestHandler)
      .setMobileAuthWithPushRequestHandler(mobileAuthenticationWithPushRequestHandler)

    initProviders(clientBuilder, customIdentityProviderConfigs)

    if (connectionTimeout != null) {
      clientBuilder.setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(connectionTimeout).toInt())
    }

    if (readTimeout != null) {
      clientBuilder.setHttpReadTimeout(TimeUnit.SECONDS.toMillis(readTimeout).toInt())
    }

    setConfigModel(clientBuilder, configModelClassName)
    setSecurityController(clientBuilder, securityControllerClassName)


    clientBuilder.build()
  }

  fun getCustomRegistrationActions(): ArrayList<CustomRegistrationAction> {
    return customRegistrationActions
  }

  private fun initProviders(clientBuilder: OneginiClientBuilder, customIdentityProviderConfigs: List<OWCustomIdentityProvider>?) {
    customIdentityProviderConfigs?.forEach {
      val action = when (it.isTwoStep) {
        true -> CustomTwoStepRegistrationActionImpl(it.providerId, nativeApi)
        false -> CustomRegistrationActionImpl(it.providerId, nativeApi)
      }

      customRegistrationActions.add(action)
      clientBuilder.addCustomIdentityProvider(CustomIdentityProvider(action))
    }
  }

  private fun setConfigModel(clientBuilder: OneginiClientBuilder, configModelClassName: String?) {
    if (configModelClassName == null) {
      return
    }
    try {
      val clazz = Class.forName(configModelClassName)
      val ctor = clazz.getConstructor()
      val `object` = ctor.newInstance()
      if (`object` is OneginiClientConfigModel) {
        clientBuilder.setConfigModel(`object`)
      }
    } catch (e: Exception) {
      e.message?.let { message ->
        throw SdkError(
          code = CONFIG_ERROR.code,
          message = message
        )
      } ?: throw SdkError(CONFIG_ERROR)
    }
  }

  private fun setSecurityController(clientBuilder: OneginiClientBuilder, securityControllerClassName: String?) {
    if (securityControllerClassName == null) {
      return
    }
    try {
      val securityController = Class.forName(securityControllerClassName)
      clientBuilder.setSecurityController(securityController)
    } catch (e: ClassNotFoundException) {
      e.message?.let { message ->
        throw SdkError(
          code = NOT_FOUND_SECURITY_CONTROLLER.code,
          message = message
        )
      } ?: throw SdkError(NOT_FOUND_SECURITY_CONTROLLER)
    }
  }
}
