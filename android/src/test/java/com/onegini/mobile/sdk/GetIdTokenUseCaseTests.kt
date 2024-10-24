package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.useCases.GetIdTokenUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetIdTokenUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  private lateinit var getIdTokenUseCase: GetIdTokenUseCase

  @Before
  fun attach() {
    getIdTokenUseCase = GetIdTokenUseCase(oneginiSdk)
  }

  @Test
  fun `When the idToken is null, Then should return error as ID_TOKEN_NOT_AVAILABLE`() {
    whenever(oneginiSdk.oneginiClient.userClient.idToken).thenReturn(null)

    val result = getIdTokenUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(ID_TOKEN_NOT_AVAILABLE, result)
  }

  @Test
  fun `When the idToken exists, Then should return the idToken`() {
    whenever(oneginiSdk.oneginiClient.userClient.idToken).thenReturn("test id token")

    val result = getIdTokenUseCase()

    Assert.assertEquals(result.getOrNull(), "test id token")
  }
}