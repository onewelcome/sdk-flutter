package com.onegini.mobile.sdk

import android.content.Context
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.OneginiPlugin
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper
import com.onegini.mobile.sdk.utils.SecurityController
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class OneginiPluginTest {

    private val mockResult = Mockito.mock(MethodChannel.Result::class.java)
    private val mockContext = Mockito.mock(Context::class.java)
    private val mockConfigModel = Mockito.mock(OneginiClientConfigModel::class.java)
    private val plugin = OneginiPlugin()

    @Before
    fun attach() {
        Mockito.`when`(mockConfigModel.appIdentifier).thenReturn("ExampleApp")
        Mockito.`when`(mockConfigModel.appPlatform).thenReturn("android")
        Mockito.`when`(mockConfigModel.appVersion).thenReturn("6.0.0")
        Mockito.`when`(mockConfigModel.baseUrl).thenReturn("https://token-mobile.test.onegini.com")
        Mockito.`when`(mockConfigModel.resourceBaseUrl).thenReturn("https://token-mobile.test.onegini.com/resources/")
        Mockito.`when`(mockConfigModel.keyStoreHash).thenReturn("ebbcab87e2d16b9441559767a7c85fbaea9a3feef94451990423019a31e5bf1f")
        Mockito.`when`(mockConfigModel.redirectUri).thenReturn("oneginiexample://loginsuccess")
        Mockito.`when`(mockConfigModel.certificatePinningKeyStore).thenReturn(0)

        OneginiSDK.init(mockContext,
                mockConfigModel,
                SecurityController::class.java,)
        plugin.setContext(mockContext)
    }

    @Test
    fun testStartApp() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_START_APP, null), mockResult), Unit)

    }

    @Test
    fun testRegistration() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTRATION, mapOf("scopes" to "read")), mockResult), Unit)
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTRATION, mapOf("NotHaveScope" to "read")), mockResult), Unit)
        assertEquals(RegistrationHelper.registerUser(mockContext, null, arrayOf("read"), mockResult), Unit)
    }

    @Test
    fun testCancelRegistration() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CANCEL_REGISTRATION, null), mockResult), Unit)
        assertEquals(RegistrationHelper.cancelRegistration(), Unit)
    }

    @Test
    fun testCancelPinAuth() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CANCEL_PIN_AUTH, null), mockResult), Unit)
    }

    @Test
    fun testSendPin() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_SEND_PIN, mapOf("pin" to "12345", "isAuth" to true)), mockResult), Unit)
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_SEND_PIN, mapOf("pin" to "12345", "isAuth" to false)), mockResult), Unit)
    }

    @Test
    fun testPinAuth() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_PIN_AUTHENTICATION, null), mockResult), Unit)

    }

    @Test
    fun testRegisterFingerprintAuth() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTER_FINGERPRINT_AUTHENTICATOR, null), mockResult), Unit)
    }

    @Test
    fun testSingleSignOn() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_SINGLE_SIGN_ON,  mapOf("url" to "https://login-mobile.test.onegini.com/personal/dashboard")), mockResult), Unit)
    }

    @Test
    fun testLogOut() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_LOG_OUT, null), mockResult), Unit)
    }

    @Test
    fun testDeregister() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_DEREGISTER_USER, null), mockResult), Unit)
    }
    @Test
    fun testQRCodeResponse() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_OTP_QR_CODE_RESPONSE, mapOf("data" to "test")), mockResult), Unit)
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_OTP_QR_CODE_RESPONSE, mapOf("data" to "")), mockResult), Unit)
    }

    @Test
    fun testIsUserNotRegisteredFingerprint() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_IS_USER_NOT_REGISTERED_FINGERPRINT, null), mockResult), Unit)
    }

    @Test
    fun testGetIdentityProviders() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_GET_IDENTITY_PROVIDERS, null), mockResult), Unit)
    }

    @Test
    fun testGetRegisteredAuthenticators() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_GET_REGISTERED_AUTHENTICATORS,null), mockResult), Unit)
    }

    @Test
    fun testRegistrationWithIdentityProviders() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTRATION_WITH_IDENTITY_PROVIDER, mapOf("identityProviderId" to "testID","scopes" to "read")), mockResult), Unit)
    }

    @Test
    fun testAuthenticateWithRegisteredAuthenticators() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_AUTHENTICATE_WITH_REGISTERED_AUTHENTICATION, mapOf("registeredAuthenticatorsId" to "testID")), mockResult), Unit)
    }


    @Test
    fun testChangePin() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_CHANGE_PIN, null), mockResult), Unit)
    }

}