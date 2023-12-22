package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.onegini.mobile.sdk.android.handlers.OneginiStatelessRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWCustomInfo
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWRegistrationResponse
import com.onegini.mobile.sdk.flutter.useCases.StatelessRegistrationUseCase
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*
import org.robolectric.util.ReflectionHelpers

@RunWith(MockitoJUnitRunner::class)
class StatelessRegistrationUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var callbackMock: (Result<OWRegistrationResponse>) -> Unit

  @Mock
  lateinit var oneginiIdentityProviderMock: OneginiIdentityProvider

  @Mock
  lateinit var oneginiRegistrationErrorMock: OneginiRegistrationError

  private lateinit var statelessRegistrationUseCase: StatelessRegistrationUseCase

  @Before
  fun attach() {
    statelessRegistrationUseCase = StatelessRegistrationUseCase(oneginiSdk)
  }

  @Test
  fun `When the given ID is found in the SDK identity providers, Then it should match the IDs with the identity provider id as a parameter`() {
    val testProviderId = "testid"
    val testScopes = listOf("read")
    val setOfIdentityProviders = setOf(oneginiIdentityProviderMock)

    whenever(oneginiIdentityProviderMock.id).thenReturn(testProviderId)
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOfIdentityProviders)

    statelessRegistrationUseCase(testProviderId, testScopes, callbackMock)

    argumentCaptor<OneginiIdentityProvider> {
      verify(oneginiSdk.oneginiClient.userClient).registerStatelessUser(capture(), eq(arrayOf("read")), any())
      assertThat(firstValue.id).isEqualTo(testProviderId)
    }
  }

  @Test
  fun `When the given ID is not found in the SDK identity providers, Then it should return error`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("testid1")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))

    statelessRegistrationUseCase("testid2", listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      SdkErrorAssert.assertEquals(NOT_FOUND_IDENTITY_PROVIDER, firstValue.exceptionOrNull())
    }
  }

  @Test
  fun `When given identity provider id is found in SDK identity providers, Then it should call result success with identity provider id as a param`() {
    whenever(oneginiIdentityProviderMock.id).thenReturn("testid")
    whenever(oneginiSdk.oneginiClient.userClient.identityProviders).thenReturn(setOf(oneginiIdentityProviderMock))
    whenever(oneginiSdk.oneginiClient.userClient.registerStatelessUser(isNotNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiStatelessRegistrationHandler>(2).onSuccess(CustomInfo(0, ""))
    }

    statelessRegistrationUseCase("testid", listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())
      val testProfile = OWUserProfile("stateless")
      val testInfo = OWCustomInfo(0, "")
      Assert.assertEquals(firstValue.getOrNull(), OWRegistrationResponse(testProfile, testInfo))
    }
  }

  @Test
  fun `When given scopes contains two strings, Then the scopes param should be array of two scopes`() {
    statelessRegistrationUseCase(null, listOf("read", "write"), callbackMock)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerStatelessUser(isNull(), capture(), any())
      assertThat(firstValue.size).isEqualTo(2)
      assertThat(firstValue).isEqualTo(arrayOf("read", "write"))
    }
  }

  @Test
  fun `When given scopes is null, Then the scopes param should be be an array of null`() {
    statelessRegistrationUseCase(null, null, callbackMock)

    argumentCaptor<Array<String>> {
      verify(oneginiSdk.oneginiClient.userClient).registerStatelessUser(isNull(), capture(), any())
      assertThat(firstValue).isNull()
    }
  }

  @Test
  fun `When given identity provider id is null, Then it should call 'registerStatelessUser' method once`() {
    statelessRegistrationUseCase(null, listOf("read"), callbackMock)

    verify(oneginiSdk.oneginiClient.userClient).registerStatelessUser(isNull(), eq(arrayOf("read")), any())
  }

  @Test
  fun `When registerStatelessUser method return an error, Then the wrapper function should return error`() {
    ReflectionHelpers.setField(oneginiRegistrationErrorMock, "errorType", OneginiRegistrationError.STATELESS_REGISTRATION_ERROR);
    whenever(oneginiRegistrationErrorMock.message).thenReturn("Stateless registration error")

    whenever(oneginiSdk.oneginiClient.userClient.registerStatelessUser(isNull(), eq(arrayOf("read")), any())).thenAnswer {
      it.getArgument<OneginiStatelessRegistrationHandler>(2).onError(oneginiRegistrationErrorMock)
    }

    statelessRegistrationUseCase(null, listOf("read"), callbackMock)

    argumentCaptor<Result<OWRegistrationResponse>>().apply {
      verify(callbackMock).invoke(capture())

      val expected = FlutterError(oneginiRegistrationErrorMock.errorType.toString(), oneginiRegistrationErrorMock.message)
      SdkErrorAssert.assertEquals(expected, firstValue.exceptionOrNull())
    }
  }
}