package com.onegini.mobile.sdk

import android.content.Context
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.IOneginiClient
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.providers.CustomTwoStepIdentityProvider
import com.onegini.mobile.sdk.utils.OneginiConfigModel
import com.onegini.mobile.sdk.utils.SecurityController
import io.flutter.plugin.common.MethodChannel
import io.mockk.MockKAnnotations
import io.mockk.every
import io.mockk.impl.annotations.MockK
import io.mockk.impl.annotations.RelaxedMockK
import io.mockk.mockk
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito.mock
import org.mockito.MockitoAnnotations

class OneginiPluginTest {


    @MockK
    lateinit var client: OneginiClient

    @MockK
    lateinit var oneginiSDK: IOneginiClient

    @MockK
    lateinit var userClient: UserClient


    @RelaxedMockK
    lateinit var mockAndroidContext: Context

    private val mockResult = mock(MethodChannel.Result::class.java)


    @Before
    fun attach() {
        MockitoAnnotations.initMocks(this)
        MockKAnnotations.init(this, relaxUnitFun = true)
        OneginiSDK.oneginiClientConfigModel = OneginiConfigModel()
        OneginiSDK.oneginiSecurityController = SecurityController::class.java
        every { oneginiSDK.initSDK(mockAndroidContext) } returns client
        every { oneginiSDK.getOneginiClient(mockAndroidContext) } returns client
        every { client.userClient } returns userClient

    }

    @Test
    fun testStartApp() {
        val twoStepCustomIdentityProviderIds: String? = null
        val oneginiCustomIdentityProviderList = mutableListOf<OneginiCustomIdentityProvider>()
        val identityProviderIds = twoStepCustomIdentityProviderIds?.split(",")?.map { it.trim() }
        identityProviderIds?.forEach { oneginiCustomIdentityProviderList.add(CustomTwoStepIdentityProvider(it)) }
        val oneginiClient: OneginiClient = oneginiSDK.getOneginiClient(mockAndroidContext)
        oneginiClient.start(object : OneginiInitializationHandler {
            override fun onSuccess(removedUserProfiles: Set<UserProfile?>?) {
                mockResult.success(Gson().toJson(removedUserProfiles))
            }

            override fun onError(error: OneginiInitializationError) {
                mockResult.error(error.errorType.toString(), error.message, null)
            }
        })
    }

    @Test
    fun testRegistrationWithIdentityProvider() {
        val provider = mockk<OneginiIdentityProvider>()
        every { provider.id } returns "test"
        every { userClient.identityProviders } returns mutableSetOf(provider)
        val identityProviderId = "test"
        val identityProviders = oneginiSDK.getOneginiClient(mockAndroidContext).userClient.identityProviders
        for (identityProvider in identityProviders) {
            if (identityProvider.id == identityProviderId) {
                assert(true)
                break
            }
            assert(false)
        }


    }
//
//    @Test
//    fun testCancelRegistration() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CANCEL_REGISTRATION, null), mockResult), Unit)
//        assertEquals(RegistrationHelper.cancelRegistration(), Unit)
//    }
//
//    @Test
//    fun testCancelPinAuth() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CANCEL_PIN_AUTH, null), mockResult), Unit)
//    }
//
//    @Test
//    fun testSendPin() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_SEND_PIN, mapOf("pin" to "12345", "isAuth" to true)), mockResult), Unit)
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_SEND_PIN, mapOf("pin" to "12345", "isAuth" to false)), mockResult), Unit)
//    }
//
//    @Test
//    fun testPinAuth() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_PIN_AUTHENTICATION, null), mockResult), Unit)
//
//    }
//
//    @Test
//    fun testRegisterFingerprintAuth() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTER_FINGERPRINT_AUTHENTICATOR, null), mockResult), Unit)
//    }
//
//    @Test
//    fun testSingleSignOn() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_GET_APP_TO_WEB_SINGLE_SIGN_ON, mapOf("url" to "https://login-mobile.test.onegini.com/personal/dashboard")), mockResult), Unit)
//    }
//
//    @Test
//    fun testLogOut() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_LOG_OUT, null), mockResult), Unit)
//    }
//
//    @Test
//    fun testDeregister() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_DEREGISTER_USER, null), mockResult), Unit)
//    }
//    @Test
//    fun testQRCodeResponse() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_OTP_QR_CODE_RESPONSE, mapOf("data" to "test")), mockResult), Unit)
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_OTP_QR_CODE_RESPONSE, mapOf("data" to "")), mockResult), Unit)
//    }
//
//    @Test
//    fun testIsUserNotRegisteredFingerprint() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_IS_USER_NOT_REGISTERED_FINGERPRINT, null), mockResult), Unit)
//    }
//
//    @Test
//    fun testGetIdentityProviders() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_GET_IDENTITY_PROVIDERS, null), mockResult), Unit)
//    }
//
//    @Test
//    fun testGetRegisteredAuthenticators() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_GET_REGISTERED_AUTHENTICATORS,null), mockResult), Unit)
//    }
//
//    @Test
//    fun testRegistrationWithIdentityProviders() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER, mapOf("identityProviderId" to "testID","scopes" to "read")), mockResult), Unit)
//    }
//
//    @Test
//    fun testAuthenticateWithRegisteredAuthenticators() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_AUTHENTICATE_WITH_REGISTERED_AUTHENTICATION, mapOf("registeredAuthenticatorsId" to "testID")), mockResult), Unit)
//    }
//
//
//    @Test
//    fun testChangePin() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CHANGE_PIN, null), mockResult), Unit)
//    }

}
