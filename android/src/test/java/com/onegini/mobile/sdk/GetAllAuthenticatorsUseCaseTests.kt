package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetAllAuthenticatorsUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAllAuthenticatorsUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var callMock: MethodCall

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  @Spy
  lateinit var resultSpy: MethodChannel.Result

  lateinit var getAllAuthenticatorsUseCase: GetAllAuthenticatorsUseCase

  @Before
  fun attach() {
    getAllAuthenticatorsUseCase = GetAllAuthenticatorsUseCase(oneginiSdk)
  }

  @Test
  fun `When an unknown or unregistered profileId is given then an error should be thrown`() {
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("ABCDEF")))

    getAllAuthenticatorsUseCase(callMock, resultSpy)

    val message = USER_PROFILE_DOES_NOT_EXIST.message
    verify(resultSpy).error(eq(USER_PROFILE_DOES_NOT_EXIST.code.toString()), eq(message), any())
  }

  @Test
  fun `When getAllAuthenticators method return empty set then the function should return empty`() {
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(UserProfile("QWERTY"))).thenReturn(emptySet())

    getAllAuthenticatorsUseCase(callMock, resultSpy)

    val expectedResult = Gson().toJson(emptyArray<Map<String, String>>())
    verify(resultSpy).success(expectedResult)
  }

  @Test
  fun `When a registered profileId is given and getAllAuthenticatorsUseCase contains authenticators then an array of maps should be returned`() {
    whenever(callMock.argument<String>("profileId")).thenReturn("QWERTY")
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))
    whenever(oneginiSdk.oneginiClient.userClient.getAllAuthenticators(UserProfile("QWERTY"))).thenReturn(setOf(oneginiAuthenticatorMock))
    whenever(oneginiAuthenticatorMock.name).thenReturn("test")
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")

    getAllAuthenticatorsUseCase(callMock, resultSpy)

    val expectedResult = Gson().toJson(arrayOf(mapOf("id" to "test", "name" to "test")))
    verify(resultSpy).success(expectedResult)
  }
}
