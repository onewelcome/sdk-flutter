package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWIdentityProvider
import com.onegini.mobile.sdk.flutter.useCases.GetIdentityProvidersUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetIdentityProvidersUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var oneginiIdentityProviderFirstMock: OneginiIdentityProvider

  @Mock
  lateinit var oneginiIdentityProviderSecondMock: OneginiIdentityProvider

  private lateinit var getIdentityProvidersUseCase: GetIdentityProvidersUseCase

  @Before
  fun attach() {
    getIdentityProvidersUseCase = GetIdentityProvidersUseCase(oneginiSdk)
  }

  @Test
  fun `When the sdk returns an empty set, Then it should return an empty list`() {
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(emptySet())

    val result = getIdentityProvidersUseCase()

    Assert.assertEquals(result.getOrNull(), mutableListOf<List<OWIdentityProvider>>())
  }

  @Test
  fun `When the user has available identity providers, Then it should return list of identity providers`() {
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(
      setOf(
        oneginiIdentityProviderFirstMock,
        oneginiIdentityProviderSecondMock
      )
    )
    whenever(oneginiIdentityProviderFirstMock.id).thenReturn("firstId")
    whenever(oneginiIdentityProviderFirstMock.name).thenReturn("firstName")
    whenever(oneginiIdentityProviderSecondMock.id).thenReturn("secondId")
    whenever(oneginiIdentityProviderSecondMock.name).thenReturn("secondName")

    val result = getIdentityProvidersUseCase()

    when (val identityProviders = result.getOrNull()) {
      is List<OWIdentityProvider> -> {
        Assert.assertEquals(identityProviders[0].id, "firstId")
        Assert.assertEquals(identityProviders[0].name, "firstName")
        Assert.assertEquals(identityProviders[1].id, "secondId")
        Assert.assertEquals(identityProviders[1].name, "secondName")
      }
      else -> Assert.fail(OneWelcomeWrapperErrors.UNEXPECTED_ERROR_TYPE.message)
    }
  }
}
