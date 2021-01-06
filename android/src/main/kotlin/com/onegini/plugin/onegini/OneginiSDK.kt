package com.onegini.plugin.onegini


import android.content.Context
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.plugin.onegini.handlers.CreatePinRequestHandler
import com.onegini.plugin.onegini.handlers.PinAuthenticationRequestHandler
import com.onegini.plugin.onegini.handlers.RegistrationRequestHandler
import java.util.concurrent.TimeUnit



class OneginiSDK {

    companion object{
        private var oneginiClientConfigModel: OneginiClientConfigModel? = null
        private var oneginiSecurityController : Class<*>? = null
        private var httpConnectionTimeout : Long = 5
        private var httpReadTimeout : Long = 20
        private var oneginiCustomIdentityProviders = mutableListOf<OneginiCustomIdentityProvider>()


        fun setOneginiClientConfigModel(configModel: OneginiClientConfigModel){
            oneginiClientConfigModel = configModel
        }

        fun setSecurityController(securityController: Class<*>){
            oneginiSecurityController = securityController
        }

        fun setConnectionTimeout(connectionTimeout : Long){
            httpConnectionTimeout = connectionTimeout
        }

        fun setReadTimeout(readTimeout : Long){
            httpReadTimeout = readTimeout
        }

        fun getOneginiClient(context: Context): OneginiClient? {
            var oneginiClient = OneginiClient.getInstance()
            if (oneginiClient == null) {
                oneginiClient = buildSDK(context)
            }
            return oneginiClient
        }

        fun addCustomIdentityProvider(oneginiCustomIdentityProvider: OneginiCustomIdentityProvider){
            oneginiCustomIdentityProviders.add(oneginiCustomIdentityProvider)
        }

        private fun buildSDK(context: Context): OneginiClient? {
            if(oneginiClientConfigModel == null) throw Exception("OneginiClientConfigModel must be not null!")
            val applicationContext = context.applicationContext ?: return null
            val registrationRequestHandler = RegistrationRequestHandler(applicationContext)
            val pinAuthenticationRequestHandler = PinAuthenticationRequestHandler(applicationContext)
            val createPinRequestHandler = CreatePinRequestHandler(applicationContext)
            val clientBuilder = OneginiClientBuilder(applicationContext, createPinRequestHandler, pinAuthenticationRequestHandler) // handlers for optional functionalities
                    .setBrowserRegistrationRequestHandler(registrationRequestHandler)
                    .setHttpConnectTimeout(TimeUnit.SECONDS.toMillis(httpConnectionTimeout).toInt())
                    .setHttpReadTimeout(TimeUnit.SECONDS.toMillis(httpReadTimeout).toInt())
                    .setSecurityController(oneginiSecurityController)
                    .setConfigModel(oneginiClientConfigModel)
            oneginiCustomIdentityProviders.map { clientBuilder.addCustomIdentityProvider(it) }
            return clientBuilder.build()
        }
    }

}