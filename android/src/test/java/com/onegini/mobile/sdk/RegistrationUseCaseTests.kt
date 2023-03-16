package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class RegistrationUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var callbackMock: (Result<OWRegistrationResponse>) -> Unit

  @Mock
  lateinit var oneginiIdentityProviderMock: OneginiIdentityProvider

  lateinit var registrationUseCase: RegistrationUseCase

  @Before
  fun attach() {
    registrationUseCase = RegistrationUseCase(oneginiSdk)
  }

  @Test
  fun `when given identity provider id is null, Then it should resolve with success with identity provider id as a param`() {
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(emptySet())
    whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    registrationUseCase(null, listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When the given ID is found in the SDK identity providers, Then it should match the IDs with the identity provider id as a parameter`() {
    val testProviderId = "testId"
    val testScopes = listOf("read")
    val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

    whenever(oneginiIdentityProviderMock.id).thenReturn(testProviderId)
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)

    registrationUseCase(testProviderId, testScopes, callbackMock)

    argumentCaptor<OneginiIdentityProvider> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(capture(), eq(arrayOf("read")), any())
      assertThat(firstValue.id).isEqualTo(testProviderId)
    }
  }

  @Test
  fun `When the given ID is not found in the SDK identity providers, Then it should return error`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("id")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))

    registrationUseCase("differentId", listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(IDENTITY_PROVIDER_NOT_FOUND, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When given identity provider id is found in SDK identity providers, Then it should call result success with identity provider id as a param`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))
    whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNotNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    registrationUseCase("testId", listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `When given identity provider id is null, Then it should call 'registerUser' method once`() {
    registrationUseCase(null, listOf("read"), callbackMock)

    verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), eq(arrayOf("read")), any())
  }

  @Test
  fun `When given scopes contains two strings, Then the scopes param should be array of two scopes`() {
    registrationUseCase(null, listOf("read", "write"), callbackMock)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
      assertThat(firstValue.size).isEqualTo(2)
      assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }

  @Test
  fun `When given scopes is null, Then the scopes param should be be an array of null`() {
    registrationUseCase(null, null, callbackMock)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
      assertThat(firstValue).isNull()
    }
  }
}
