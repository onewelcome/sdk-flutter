package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.OneginiAuthenticator
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWAuthenticatorType
import com.onegini.mobile.sdk.flutter.useCases.SetPreferredAuthenticatorUseCase
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
  lateinit var oneginiAuthenticatorMock: OneginiAuthenticator

  private lateinit var setPreferredAuthenticatorUseCase: SetPreferredAuthenticatorUseCase

  private val profileId = "QWERTY"
  @Before
  fun attach() {
    setPreferredAuthenticatorUseCase = SetPreferredAuthenticatorUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then return an NO_USER_PROFILE_IS_AUTHENTICATED error`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    val result = setPreferredAuthenticatorUseCase(OWAuthenticatorType.BIOMETRIC).exceptionOrNull()

    SdkErrorAssert.assertEquals(NO_USER_PROFILE_IS_AUTHENTICATED, result)
  }

  @Test
  fun `When an authenticatorType is given that is not related to the authenticated user, Then should reject with AUTHENTICATOR_NOT_FOUND`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile(profileId))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile(profileId)))).thenReturn(emptySet())

    val result = setPreferredAuthenticatorUseCase(OWAuthenticatorType.BIOMETRIC).exceptionOrNull()

    SdkErrorAssert.assertEquals(AUTHENTICATOR_NOT_FOUND, result)
  }

  @Test
  fun `When the given authenticatorType is biometric and is registered, Then it should resolve with success`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile(profileId))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile(profileId)))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.FINGERPRINT)

    val result = setPreferredAuthenticatorUseCase(OWAuthenticatorType.BIOMETRIC)

    Assert.assertEquals(result.getOrNull(), Unit)
  }

  @Test
  fun `When the given authenticatorType is pin and is registered, Then it should resolve with success`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile(profileId))
    whenever(oneginiSdk.oneginiClient.userClient.getRegisteredAuthenticators(eq(UserProfile(profileId)))).thenReturn(
      setOf(
        oneginiAuthenticatorMock
      )
    )
    whenever(oneginiAuthenticatorMock.type).thenReturn(OneginiAuthenticator.PIN)

    val result = setPreferredAuthenticatorUseCase(OWAuthenticatorType.PIN)

    Assert.assertEquals(result.getOrNull(), Unit)
  }
}
