package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.useCases.GetAuthenticatedUserProfileUseCase
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.eq
import org.mockito.kotlin.isNull
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAuthenticatedUserProfileUseCaseTests {

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
    fun `should return null UserProfile when user is not authenticated`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(null)

        GetAuthenticatedUserProfileUseCase(clientMock)(resultSpy)

        Mockito.verify(resultSpy).success(isNull())
    }

    @Test
    fun `should return right UserProfile when user is authenticated`() {
        whenever(userClientMock.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        GetAuthenticatedUserProfileUseCase(clientMock)(resultSpy)

        val expectedResult = Gson().toJson(UserProfile("QWERTY"))
        Mockito.verify(resultSpy).success(eq(expectedResult))
    }
}
