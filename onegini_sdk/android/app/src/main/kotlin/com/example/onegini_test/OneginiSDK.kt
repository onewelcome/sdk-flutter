package com.example.onegini_test


import android.content.Context
import com.example.onegini_test.handlers.CreatePinRequestHandler
import com.example.onegini_test.handlers.PinAuthenticationRequestHandler
import com.example.onegini_test.handlers.RegistrationRequestHandler
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
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
                    .setBrowserRegistrationRequestHandler(registrationRequestHandler) // Set http connect / read timeout
                    .setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(5).toInt())
                    .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(20).toInt())
                    .setConfigModel(OneginiConfigModel())
                    .setSecurityController(SecurityController::class.java)

            return clientBuilder.build()
        }
    }
}