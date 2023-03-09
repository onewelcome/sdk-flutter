package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.useCases.GetRegisteredAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import junit.framework.Assert.fail
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetRegisteredAuthenticatorsUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var oneginiAuthenticatorFirstMock: OneginiAuthenticator

    @Mock
    lateinit var oneginiAuthenticatorSecondMock: OneginiAuthenticator

    lateinit var getRegisteredAuthenticatorsUseCase: GetRegisteredAuthenticatorsUseCase
    @Before
    fun attach() {
        val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
        getRegisteredAuthenticatorsUseCase = GetRegisteredAuthenticatorsUseCase(oneginiSdk, getUserProfileUseCase)
    }

    @Test
    fun `should return empty list when sdk return empty set`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

        val result = getRegisteredAuthenticatorsUseCase("QWERTY")

        Assert.assertEquals(result.getOrNull(), mutableListOf<List<OWAuthenticator>>())
    }

    @Test
    fun `When UserProfile is null, Then it should return an error`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

        val result = getRegisteredAuthenticatorsUseCase("QWERTY")

        when (val error = result.exceptionOrNull()) {
            is FlutterError -> {
                Assert.assertEquals(error.code.toInt(), USER_PROFILE_DOES_NOT_EXIST.code)
                Assert.assertEquals(error.message, USER_PROFILE_DOES_NOT_EXIST.message)
            }
            else -> fail(UNEXPECTED_ERROR_TYPE.message)
        }
    }

    @Test
    fun `When getRegisteredAuthenticators method returns not empty set, Then it should return list of registered authenticators `() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
        whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(setOf(oneginiAuthenticatorFirstMock, oneginiAuthenticatorSecondMock))
        whenever(oneginiAuthenticatorFirstMock.id).thenReturn("firstId")
        whenever(oneginiAuthenticatorFirstMock.name).thenReturn("firstName")
        whenever(oneginiAuthenticatorFirstMock.isRegistered).thenReturn(true)
        whenever(oneginiAuthenticatorFirstMock.isPreferred).thenReturn(true)
        whenever(oneginiAuthenticatorFirstMock.type).thenReturn(5)

        whenever(oneginiAuthenticatorSecondMock.id).thenReturn("secondId")
        whenever(oneginiAuthenticatorSecondMock.name).thenReturn("secondName")
        whenever(oneginiAuthenticatorSecondMock.isRegistered).thenReturn(true)
        whenever(oneginiAuthenticatorSecondMock.isPreferred).thenReturn(false)
        whenever(oneginiAuthenticatorSecondMock.type).thenReturn(6)

        val result = getRegisteredAuthenticatorsUseCase("QWERTY")

        when (val authenticators = result.getOrNull()) {
            is List<OWAuthenticator> -> {
                Assert.assertEquals(authenticators[0].id, "firstId")
                Assert.assertEquals(authenticators[0].name, "firstName")
                Assert.assertEquals(authenticators[0].isRegistered, true)
                Assert.assertEquals(authenticators[0].isPreferred, true)
                Assert.assertEquals(authenticators[0].authenticatorType, 5)

                Assert.assertEquals(authenticators[1].id, "secondId")
                Assert.assertEquals(authenticators[1].name, "secondName")
                Assert.assertEquals(authenticators[1].isRegistered, true)
                Assert.assertEquals(authenticators[1].isPreferred, false)
                Assert.assertEquals(authenticators[1].authenticatorType, 6)
            }
            else -> fail(UNEXPECTED_ERROR_TYPE.message)
        }
    }
}
