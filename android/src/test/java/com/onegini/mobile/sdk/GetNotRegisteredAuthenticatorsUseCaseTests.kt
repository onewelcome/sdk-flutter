package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.useCases.GetNotRegisteredAuthenticatorsUseCase
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
class GetNotRegisteredAuthenticatorsUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiAuthenticatorFirstMock: OneginiAuthenticator

  @Mock
  lateinit var oneginiAuthenticatorSecondMock: OneginiAuthenticator

  private lateinit var getNotRegisteredAuthenticatorsUseCase: GetNotRegisteredAuthenticatorsUseCase

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    getNotRegisteredAuthenticatorsUseCase = GetNotRegisteredAuthenticatorsUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `When there are no Unregistered Authenticators, Then an empty set should be returned`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

    val result = getNotRegisteredAuthenticatorsUseCase("QWERTY")

    Assert.assertEquals(result.getOrNull(), mutableListOf<List<OWAuthenticator>>())
  }

  @Test
  fun `When the UserProfile is not found, Then an error should be returned`() {
    val result = getNotRegisteredAuthenticatorsUseCase("QWERTY").exceptionOrNull()

    SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, result)
  }

  @Test
  fun `When a valid UserProfile is given and multiple not registered authenticators are found, Then getNotRegisteredAuthenticators should return a non-empty set`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getNotRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorFirstMock,
        oneginiAuthenticatorSecondMock
      )
    )
    whenever(oneginiAuthenticatorFirstMock.id).thenReturn("firstId")
    whenever(oneginiAuthenticatorFirstMock.name).thenReturn("firstName")
    whenever(oneginiAuthenticatorFirstMock.isRegistered).thenReturn(false)
    whenever(oneginiAuthenticatorFirstMock.isPreferred).thenReturn(true)
    whenever(oneginiAuthenticatorFirstMock.type).thenReturn(5)

    whenever(oneginiAuthenticatorSecondMock.id).thenReturn("secondId")
    whenever(oneginiAuthenticatorSecondMock.name).thenReturn("secondName")
    whenever(oneginiAuthenticatorSecondMock.isRegistered).thenReturn(false)
    whenever(oneginiAuthenticatorSecondMock.isPreferred).thenReturn(false)
    whenever(oneginiAuthenticatorSecondMock.type).thenReturn(6)

    val result = getNotRegisteredAuthenticatorsUseCase("QWERTY")

    when (val authenticators = result.getOrNull()) {
      is List<OWAuthenticator> -> {
        Assert.assertEquals(authenticators[0].id, "firstId")
        Assert.assertEquals(authenticators[0].name, "firstName")
        Assert.assertEquals(authenticators[0].isRegistered, false)
        Assert.assertEquals(authenticators[0].isPreferred, true)
        Assert.assertEquals(authenticators[0].authenticatorType, 5)

        Assert.assertEquals(authenticators[1].id, "secondId")
        Assert.assertEquals(authenticators[1].name, "secondName")
        Assert.assertEquals(authenticators[1].isRegistered, false)
        Assert.assertEquals(authenticators[1].isPreferred, false)
        Assert.assertEquals(authenticators[1].authenticatorType, 6)
      }
      else -> fail(UNEXPECTED_ERROR_TYPE.message)
    }
  }
}
