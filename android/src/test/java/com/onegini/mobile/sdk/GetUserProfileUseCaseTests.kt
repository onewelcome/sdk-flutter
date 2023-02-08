package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.useCases.FetchUserProfilesUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetUserProfileUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return empty set when SDK returns empty set`() {
        whenever(userClientMock.userProfiles).thenReturn(emptySet())

        FetchUserProfilesUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success(Gson().toJson(emptySet<UserProfile>()))
    }

    @Test
    fun `should return single UserProfile when SDK returns one UserProfile`() {
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY")))

        FetchUserProfilesUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(setOf(mapOf( "isDefault" to false, "profileId" to "QWERTY")))
        Mockito.verify(resultSpy).success(eq(expectedResult))
    }

    @Test
    fun `should return UserProfile set when SDK returns set of UserProfile`() {
        whenever(userClientMock.userProfiles).thenReturn(setOf(UserProfile("QWERTY"), UserProfile("ASDFGH")))

        FetchUserProfilesUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"),mapOf("isDefault" to false, "profileId" to "ASDFGH")))
        Mockito.verify(resultSpy).success(eq(expectedResult))
    }
}