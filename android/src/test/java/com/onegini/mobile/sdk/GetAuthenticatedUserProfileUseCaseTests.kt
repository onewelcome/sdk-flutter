package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.useCases.GetAuthenticatedUserProfileUseCase
import junit.framework.Assert.fail
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAuthenticatedUserProfileUseCaseTests {

  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  lateinit var getAuthenticatedUserProfileUseCase: GetAuthenticatedUserProfileUseCase

  @Before
  fun attach() {
    getAuthenticatedUserProfileUseCase = GetAuthenticatedUserProfileUseCase(oneginiSdk)
  }

  @Test
  fun `When no user is authenticated, Then should reject with NO_USER_PROFILE_IS_AUTHENTICATED`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

    val result = getAuthenticatedUserProfileUseCase()

    when (val error = result.exceptionOrNull()) {
      is FlutterError -> {
        Assert.assertEquals(error.code.toInt(), NO_USER_PROFILE_IS_AUTHENTICATED.code)
        Assert.assertEquals(error.message, NO_USER_PROFILE_IS_AUTHENTICATED.message)
      }
      else -> fail("Test failed as no sdk error was passed")
    }
  }

  @Test
  fun `When a user is authenticated, Then should return the userProfile as JSON`() {
    whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

    val result = getAuthenticatedUserProfileUseCase().getOrNull()

    Assert.assertEquals(result?.profileId, "QWERTY")
  }
}
