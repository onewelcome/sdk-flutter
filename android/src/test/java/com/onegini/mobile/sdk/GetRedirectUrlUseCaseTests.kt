package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiClientConfigModel
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetRedirectUrlUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetRedirectUrlUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var oneginiClientConfigModelMock: OneginiClientConfigModel

  lateinit var getRedirectUrlUseCase: GetRedirectUrlUseCase

  @Before
  fun attach() {
    getRedirectUrlUseCase = GetRedirectUrlUseCase(oneginiSdk)
    whenever(oneginiSdk.oneginiClient.configModel).thenReturn(oneginiClientConfigModelMock)
  }

  @Test
  fun `When redirectUri is an empty string, Then call success with empty string`() {
    whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("")

    val result = getRedirectUrlUseCase()

    Assert.assertEquals(result.getOrNull(), "")
  }

  @Test
  fun `When redirectUri is a non-empty string, Then call sucess with that string`() {
    whenever(oneginiClientConfigModelMock.redirectUri).thenReturn("http://test.com")

    val result = getRedirectUrlUseCase()

    Assert.assertEquals(result.getOrNull(), "http://test.com")
  }
}
