package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.useCases.GetAccessTokenUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAccessTokenUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  private lateinit var getAccessTokenUseCase: GetAccessTokenUseCase

  @Before
  fun attach() {
    getAccessTokenUseCase = GetAccessTokenUseCase(oneginiSdk)
  }

  @Test
  fun `When the accessToken is null, Then should error with NO_USER_PROFILE_IS_AUTHENTICATED`() {
    whenever(oneginiSdk.oneginiClient.userClient.accessToken).thenReturn(null)

    val result = getAccessTokenUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(NOT_AUTHENTICATED_USER, result)
  }

  @Test
  fun `When the accessToken exists, Then should return the accessToken`() {
    whenever(oneginiSdk.oneginiClient.userClient.accessToken).thenReturn("test access token")

    val result = getAccessTokenUseCase()

    Assert.assertEquals(result.getOrNull(), "test access token")
  }
}
