package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
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
class SetPreferredAuthenticatorUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  @Mock
  lateinit var clientMock: OneginiClient

  @Mock
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  lateinit var setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase

  @Before
  fun attach() {
    setPreferredAuthenticatorUseCase = SetPreferredAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then return an error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    when (val error = setPreferredAuthenticatorUseCase("test").exceptionOrNull()) {
      is SdkError -> {
        Assert.assertEquals(error.code, NO_USER_PROFILE_IS_AUTHENTICATED.code)
        Assert.assertEquals(error.message, NO_USER_PROFILE_IS_AUTHENTICATED.message)
      }
      else -> fail(UNEXPECTED_ERROR_TYPE.message)
    }
  }

  @Test
  fun `When an authenticator id is given that is not related to the authenticated user, Then an error should be thrown`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(emptySet())

    setPreferredAuthenticatorUseCase("test")

    when (val error = setPreferredAuthenticatorUseCase("test").exceptionOrNull()) {
      is SdkError -> {
        Assert.assertEquals(error.code, AUTHENTICATOR_NOT_FOUND.code)
        Assert.assertEquals(error.message, AUTHENTICATOR_NOT_FOUND.message)
      }
      else -> fail(UNEXPECTED_ERROR_TYPE.message)
    }
  }

  @Test
  fun `When the given authenticator id is found and registered, Then it should resolve with success`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile("QWERTY")))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.id).thenReturn("test")

    val result = setPreferredAuthenticatorUseCase("test")

    Assert.assertEquals(result.getOrNull(), Unit)
  }
}
