package com.onegini.mobile.sdk

import android.content.Context
import android.net.Uri
import com.onegini.mobile.sdk.android.client.DeviceClient
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OnMethodCallMapper
import com.onegini.mobile.sdk.flutter.constants.Constants
import com.onegini.mobile.sdk.flutter.handlers.RegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.helpers.AuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.MobileAuthenticationObject
import com.onegini.mobile.sdk.flutter.helpers.RegistrationHelper
import com.onegini.mobile.sdk.flutter.helpers.ResourceHelper
import com.onegini.mobile.sdk.utils.OnegeniProvider
import com.onegini.mobile.sdk.utils.OneginiAuthenticator
import com.onegini.mobile.sdk.utils.OneginiConfigModel
import com.onegini.mobile.sdk.utils.RxSchedulerRule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.OkHttpClient
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito.*
import org.mockito.MockitoAnnotations
import org.mockito.junit.MockitoJUnitRunner


@RunWith(MockitoJUnitRunner::class)
class OneginiPluginTest {

    @Mock
    lateinit var client: OneginiClient

    @Mock
    lateinit var userClient: UserClient

    @Mock
    lateinit var userProfile: UserProfile

    @Mock
    lateinit var context: Context

    private val mockResult = mock(MethodChannel.Result::class.java)

    @get:Rule
    var rxSchedulerRule = RxSchedulerRule()

    @Before
    fun attach() {
        MockitoAnnotations.initMocks(this)
        `when`(client.userClient).thenReturn(userClient)
    }

    @Test
    fun `registration without identity provider`() {
        RegistrationHelper.registerUser(null, null, mockResult, client)
    }

    @Test
    fun `registration with identity provider`() {
        val set = mutableSetOf<OneginiIdentityProvider>()
        set.add(OnegeniProvider())
        `when`(userClient.identityProviders).thenReturn(set)
        RegistrationHelper.registerUser("test provider id", null, mockResult, client)
    }


    @Test
    fun `get identity provider list`() {
        val set = mutableSetOf<OneginiIdentityProvider>()
        set.add(OnegeniProvider())
        `when`(userClient.identityProviders).thenReturn(set)
        RegistrationHelper.getIdentityProviders(mockResult, client)
    }

    @Test
    fun `handle registration callback`() {
        RegistrationHelper.handleRegistrationCallback(Uri.parse("test url"))
    }

    @Test
    fun `cancel registration`() {
        RegistrationHelper.cancelRegistration()
    }

    @Test
    fun `start web registration`() {
        RegistrationRequestHandler(context).startRegistration(Uri.parse("test url"), mock(OneginiBrowserRegistrationCallback::class.java))
    }


    @Test
    fun `deregister user when user profile is null`() {
        RegistrationHelper.deregisterUser(mockResult, client)
    }


    @Test
    fun `deregister user`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        RegistrationHelper.deregisterUser(mockResult, client)
    }

    @Test
    fun `authenticate user when user profile is null`() {
        AuthenticationObject.authenticateUser(null, mockResult, client)
    }

    @Test
    fun `authenticate user when authenticator is null`() {
        `when`(userClient.userProfiles).thenReturn(setOf(userProfile))
        AuthenticationObject.authenticateUser(null, mockResult, client)
    }


    @Test
    fun `authenticate user by authenticator`() {
        `when`(userClient.userProfiles).thenReturn(setOf(userProfile))
        `when`(userClient.getRegisteredAuthenticators(userProfile)).thenReturn(setOf(OneginiAuthenticator()))
        AuthenticationObject.authenticateUser("test id", mockResult, client)
    }

    @Test
    fun `get registered authenticators`() {
        `when`(userClient.userProfiles).thenReturn(setOf(userProfile))
        `when`(userClient.getRegisteredAuthenticators(userProfile)).thenReturn(setOf(OneginiAuthenticator()))
        AuthenticationObject.getRegisteredAuthenticators(mockResult, client)
    }

    @Test
    fun `get registered authenticators when user profiles is null`() {
        AuthenticationObject.getRegisteredAuthenticators(mockResult, client)
    }

    @Test
    fun `get not registered authenticators`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        `when`(userClient.getNotRegisteredAuthenticators(userProfile)).thenReturn(setOf(OneginiAuthenticator()))
        AuthenticationObject.getNotRegisteredAuthenticators(mockResult, client)
    }

    @Test
    fun `register authenticator when id is null`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        `when`(userClient.getNotRegisteredAuthenticators(userProfile)).thenReturn(setOf(OneginiAuthenticator()))
        AuthenticationObject.registerAuthenticator(null, mockResult, client)
    }

    @Test
    fun `register authenticator when authenticated user is null`() {
        AuthenticationObject.registerAuthenticator(null, mockResult, client)
    }


    @Test
    fun `register authenticator`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        `when`(userClient.getNotRegisteredAuthenticators(userProfile)).thenReturn(setOf(OneginiAuthenticator()))
        AuthenticationObject.registerAuthenticator("test id", mockResult, client)
    }

    @Test
    fun `mobile auth with otp when data null`() {
        MobileAuthenticationObject.mobileAuthWithOtp(null, mockResult, client)
    }

    @Test
    fun `mobile auth with otp when authinticated profile is null`() {
        MobileAuthenticationObject.mobileAuthWithOtp("test", mockResult, client)
    }

    @Test
    fun `mobile auth with otp`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        MobileAuthenticationObject.mobileAuthWithOtp("test", mockResult, client)
    }

    @Test
    fun `mobile auth with otp when user enrollment`() {
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        `when`(userClient.isUserEnrolledForMobileAuth(userProfile)).thenReturn(true)
        MobileAuthenticationObject.mobileAuthWithOtp("test", mockResult, client)
    }

    @Test
    fun `resource - get user client`() {
        `when`(client.configModel).thenReturn(OneginiConfigModel())
        `when`(userClient.resourceOkHttpClient).thenReturn(mock(OkHttpClient::class.java))
        ResourceHelper(MethodCall(Constants.METHOD_GET_RESOURCE, mapOf("path" to "www.test.com", "headers" to hashMapOf(Pair("test", "test")), "body" to "test body", "method" to "POST")), mockResult, client).getUserClient()
    }

    @Test
    fun `resource - getImplicit`() {
        `when`(client.configModel).thenReturn(OneginiConfigModel())
        `when`(userClient.implicitResourceOkHttpClient).thenReturn(mock(OkHttpClient::class.java))
        `when`(userClient.authenticatedUserProfile).thenReturn(userProfile)
        ResourceHelper(MethodCall(Constants.METHOD_GET_IMPLICIT_RESOURCE, null), mockResult, client).getImplicit()
    }

    @Test
    fun `resource - getAnonymous`() {
        val deviceClient = mock(DeviceClient::class.java)
        `when`(client.configModel).thenReturn(OneginiConfigModel())
        `when`(client.deviceClient).thenReturn(deviceClient)
        `when`(deviceClient.anonymousResourceOkHttpClient).thenReturn(mock(OkHttpClient::class.java))
        ResourceHelper(MethodCall(Constants.METHOD_GET_RESOURCE_ANONYMOUS, null), mockResult, client).getAnonymous()
    }

    @Test
    fun `get appToWeb single sign on when url is null`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.getAppToWebSingleSignOn(null, mockResult, client)
    }

    @Test
    fun `get appToWeb single sign on when url is not match`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.getAppToWebSingleSignOn("test", mockResult, client)
    }

    @Test
    fun `get appToWeb single sign on`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.getAppToWebSingleSignOn("https://login-mobile.test.onegini.com/personal/dashboard", mockResult, client)
    }

    @Test
    fun `log out`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.logout(mockResult, client)
    }


    @Test
    fun `start change pin flow`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.startChangePinFlow(mockResult, client)
    }

    @Test
    fun `on method call with not found call`() {
        val mapper = spy(OnMethodCallMapper(context))
        mapper.onMethodCall(MethodCall("NO", null), mockResult)
    }


//    @Test
//    fun testRegistrationWithIdentityProvider() {
//        val provider = mockk<OneginiIdentityProvider>()
//        every { provider.id } returns "test"
//        every { userClient.identityProviders } returns mutableSetOf(provider)
//        val identityProviderId = "test"
//        val identityProviders = oneginiSDK.getOneginiClient(mockAndroidContext).userClient.identityProviders
//        for (identityProvider in identityProviders) {
//            if (identityProvider.id == identityProviderId) {
//                assert(true)
//                break
//            }
//            assert(false)
//        }
//
//
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
