package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWUserProfile
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfilesUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetUserProfilesUseCaseTests {
  @Mock(answer = Answers.RETURNS_DEEP_STUBS)
  lateinit var oneginiSdk: OneginiSDK

  private lateinit var getUserProfilesUseCase: GetUserProfilesUseCase

  @Before
  fun attach() {
    getUserProfilesUseCase = GetUserProfilesUseCase(oneginiSdk)
  }

  @Test
  fun `When the SDK returns an empty set, Then it should return an empty set`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

    val result = getUserProfilesUseCase()
    Assert.assertEquals(result.getOrNull(), mutableListOf<List<OWUserProfile>>())
  }

  @Test
  fun `When the SDK returns one UserProfile, Then it should return single UserProfile`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

    val result = getUserProfilesUseCase()
    Assert.assertEquals(result.getOrNull()?.first()?.profileId, "QWERTY")
  }

  @Test
  fun `When the SDK returns a set of UserProfiles, Then it should return this UserProfile set`() {
    whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY"), UserProfile("ASDFGH")))

    val result = getUserProfilesUseCase()

    when (val userProfiles = result.getOrNull()) {
      is List<OWUserProfile> -> {
        Assert.assertEquals(userProfiles[0].profileId, "QWERTY")
        Assert.assertEquals(userProfiles[1].profileId, "ASDFGH")
      }
      else -> Assert.fail(OneWelcomeWrapperErrors.UNEXPECTED_ERROR_TYPE.message)
    }
  }
}
