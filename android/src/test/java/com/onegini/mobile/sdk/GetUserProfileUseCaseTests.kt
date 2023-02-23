package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.GetUserProfilesUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetUserProfileUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient
    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getUserProfilesUseCase: GetUserProfilesUseCase
    @Before
    fun attach() {
        getUserProfilesUseCase = GetUserProfilesUseCase(oneginiSdk)
    }

    @Test
    fun `should return empty set when SDK returns empty set`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(emptySet())

        getUserProfilesUseCase(resultSpy)

        verify(resultSpy).success(Gson().toJson(emptySet<UserProfile>()))
    }

    @Test
    fun `should return single UserProfile when SDK returns one UserProfile`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

        getUserProfilesUseCase(resultSpy)

        val expectedResult = Gson().toJson(setOf(mapOf( "isDefault" to false, "profileId" to "QWERTY")))
        verify(resultSpy).success(eq(expectedResult))
    }

    @Test
    fun `should return UserProfile set when SDK returns set of UserProfile`() {
        whenever(oneginiSdk.oneginiClient.userClient.userProfiles).thenReturn(setOf(UserProfile("QWERTY"), UserProfile("ASDFGH")))

        getUserProfilesUseCase(resultSpy)

        val expectedResult = Gson().toJson(setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"),mapOf("isDefault" to false, "profileId" to "ASDFGH")))
        verify(resultSpy).success(eq(expectedResult))
    }
}