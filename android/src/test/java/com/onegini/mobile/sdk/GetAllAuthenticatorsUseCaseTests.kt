package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticator
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfileUseCase
import junit.framework.Assert.fail
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAllAuthenticatorsUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator


  lateinit var getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase

  @Before
  fun attach() {
    val getUserProfileUseCase = GetUserProfileUseCase(oneginiSdk)
    getAllAuthenticatorsUseCase = GetAllAuthenticatorsUseCase(oneginiSdk, getUserProfileUseCase)
  }

  @Test
  fun `When an unknown or unregistered profileId is given, Then an error should be thrown`() {
    val result = getAllAuthenticatorsUseCase("QWERTY").exceptionOrNull()
    SdkErrorAssert.assertEquals(USER_PROFILE_DOES_NOT_EXIST, result)
  }

  @Test
  fun `When getAllAuthenticators method return empty set, Then the function should return empty`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(UserProfile("QWERTY"))).thenReturn(emptySet())

    val result = getAllAuthenticatorsUseCase("QWERTY")

    Assert.assertEquals(result.getOrNull(), mutableListOf<List<OWAuthenticator>>())
  }

  @Test
  fun `When a registered profileId is given and getAllAuthenticatorsUseCase contains authenticators, Then an array of maps should be returned`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(UserProfile("QWERTY"))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.name).thenReturn("test")
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")
    whenever(oneginiAuthenticatorMock.isRegistered).thenReturn(true)
    whenever(oneginiAuthenticatorMock.isPreferred).thenReturn(true)
    whenever(oneginiAuthenticatorMock.type).thenReturn(5)

    val result = getAllAuthenticatorsUseCase("QWERTY")

    when (val authenticator = result.getOrNull()?.first()) {
      is OWAuthenticator -> {
        Assert.assertEquals(authenticator.id, "test")
        Assert.assertEquals(authenticator.name, "test")
        Assert.assertEquals(authenticator.isRegistered, true)
        Assert.assertEquals(authenticator.isPreferred, true)
        Assert.assertEquals(authenticator.authenticatorType, 5)
      }
      else -> fail(UNEXPECTED_ERROR_TYPE.message)
    }
  }
}
