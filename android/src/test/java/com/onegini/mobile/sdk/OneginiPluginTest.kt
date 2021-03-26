package com.onegini.mobile.sdk

import android.content.Context

import android.util.Patterns
import com.onegini.mobile.sdk.android.client.OneginiClientBuilder
import com.onegini.mobile.sdk.flutter.OneginiPlugin
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.PinAuthenticationRequestHandler
import com.onegini.mobile.sdk.flutter.handlers.PinRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper
import com.onegini.mobile.sdk.utils.OneginiConfigModel
import com.onegini.mobile.sdk.utils.SecurityController
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.MockitoAnnotations
import java.util.regex.Matcher
import java.util.regex.Pattern

class OneginiPluginTest {

    private val mockResult = mock(MethodChannel.Result::class.java)
    private val mockAndroidContext = mock(Context::class.java)
    private val plugin = OneginiPlugin()

    @Before
    fun attach() {
        MockitoAnnotations.initMocks(this)
        OneginiSDK.oneginiClientConfigModel = OneginiConfigModel()
        OneginiSDK.oneginiSecurityController = SecurityController::class.java
        val oneginiSDK = mock(OneginiSDK::class.java)
        `when`(mockAndroidContext.applicationContext).thenReturn(mockAndroidContext)
        `when`(oneginiSDK?.buildSDK(mockAndroidContext)).thenReturn(null)
        `when`(OneginiSDK.getOneginiClient(mockAndroidContext)).thenReturn(null)
        plugin.setContext(mockAndroidContext)
    }

    @Test
    fun testStartApp() {
        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_START_APP, null), mockResult), Unit)
    }

//    @Test
//    fun testRegistration() {
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTER_USER, mapOf("scopes" to "read")), mockResult), Unit)
//        assertEquals(plugin.onMethodCall(MethodCall(Constants.METHOD_REGISTER_USER, mapOf("NotHaveScope" to "read")), mockResult), Unit)
//        assertEquals(RegistrationHelper.registerUser(mockAndroidContext, null, "read", mockResult), Unit)
//    }
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
