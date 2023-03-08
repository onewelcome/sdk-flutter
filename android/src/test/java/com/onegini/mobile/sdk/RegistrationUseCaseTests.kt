package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodCall
import junit.framework.Assert.fail
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
  lateinit var callbackSpy: (Result<OWRegistrationResponse>) -> Unit

  @Mock
  lateinit var callMock: MethodCall

  @Mock
  lateinit var oneginiIdentityProviderMock: OneginiIdentityProvider

  lateinit var registrationUseCase: RegistrationUseCase

  @Before
  fun attach() {
    registrationUseCase = RegistrationUseCase(oneginiSdk)
  }

  @Test
  fun `should call result success with identity provider id as a param when given identity provider id is null`() {
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(emptySet())
    whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    registrationUseCase(null, listOf("read"), callbackSpy)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackSpy, times(1)).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `should match the IDs with the identity provider id as a parameter when the given ID is found in the SDK identity providers`() {
    val testProviderId = "testId"
    val testScopes = listOf("read")
    val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

    whenever(oneginiIdentityProviderMock.id).thenReturn(testProviderId)
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)

    registrationUseCase(testProviderId, testScopes, callbackSpy)

    argumentCaptor<OneginiIdentityProvider> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(capture(), eq(arrayOf("read")), any())
      assertThat(firstValue.id).isEqualTo(testProviderId)
    }
  }

  @Test
  fun `should return error when the given ID is not found in the SDK identity providers`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("id")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))

    registrationUseCase("differentId", listOf("read"), callbackSpy)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackSpy, times(1)).invoke(capture())

      when (val error = firstValue.exceptionOrNull()) {
        is FlutterError -> {
          Assert.assertEquals(error.message, IDENTITY_PROVIDER_NOT_FOUND.message)
          Assert.assertEquals(error.code, IDENTITY_PROVIDER_NOT_FOUND.code.toString())
        }
        else -> fail("Test failed as no sdk error was passed")
      }
    }
  }

  @Test
  fun `should call result success with identity provider id as a param when given identity provider id is found in SDK identity providers`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("testId")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))
    whenever(oneginiSdk.oneginiClient.userClient.registerUser(isNotNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
    }

    registrationUseCase("testId", listOf("read"), callbackSpy)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackSpy, times(1)).invoke(capture())
      val testUser = OWUserProfile("QWERTY")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testUser, testInfo))
    }
  }

  @Test
  fun `should call 'registerUser' method once when given identity provider id is null`() {
    registrationUseCase(null, listOf("read"), callbackSpy)

    verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), eq(arrayOf("read")), any())
  }

  @Test
  fun `should scopes param be array of two scopes when given scopes contains two strings`() {
    registrationUseCase(null, listOf("read", "write"), callbackSpy)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
      assertThat(firstValue.size).isEqualTo(2)
      assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }

  @Test
  fun `should scopes param be array of zero lengths when given scopes is null`() {
    registrationUseCase(null, null, callbackSpy)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerUser(isNull(), capture(), any())
      assertThat(firstValue).isEmpty()
    }
  }
}
