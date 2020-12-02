package com.onegini.plugin.onegini


import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.plugin.onegini.handlers.CreatePinRequestHandler
import com.onegini.plugin.onegini.handlers.PinAuthenticationRequestHandler
import com.onegini.plugin.onegini.handlers.RegistrationRequestHandler
import java.util.concurrent.TimeUnit


object SecurityController {
    const val debugDetection = false
    const val rootDetection = false
    const val debugLogs = true
}

class OneginiSDK {
    companion object{
        fun getOneginiClient(context: Context?): OneginiClient? {
            var oneginiClient = OneginiClient.getInstance()
            if (oneginiClient == null) {
                oneginiClient = buildSDK(context!!)
            }
            return oneginiClient
        }
        private fun buildSDK(context: Context): OneginiClient? {
            val applicationContext = context.applicationContext
            val registrationRequestHandler = RegistrationRequestHandler(applicationContext)
            val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler(applicationContext)
            val createPinRequestHandler = CreatePinRequestHandler(applicationContext)
            val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                    .setBrowserRegistrationRequestHandler(registrationRequestHandler)
                    .setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(5).toInt())
                    .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(20).toInt())
                    .setConfigModel(OneginiConfigModel())
                    .setSecurityController(SecurityController::class.java)
            StorageIdentityProviders.oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
            return clientBuilder.build()
        }
    }
}