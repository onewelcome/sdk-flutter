package com.onegini.mobile.sdk

import com.google.gson.Gson
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.errors.wrapperError
import com.onegini.mobile.sdk.flutter.useCases.GetAuthenticatedUserProfileUseCase
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
class GetAuthenticatedUserProfileUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK
    @Spy
    lateinit var resultSpy: MethodChannel.Result

    lateinit var getAuthenticatedUserProfileUseCase: GetAuthenticatedUserProfileUseCase
    @Before
    fun attach() {
        getAuthenticatedUserProfileUseCase = GetAuthenticatedUserProfileUseCase(oneginiSdk)
    }

    @Test
    fun `When no user is authenticated, Then should reject with NO_USER_PROFILE_IS_AUTHENTICATED`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(null)

        getAuthenticatedUserProfileUseCase(resultSpy)

        verify(resultSpy).wrapperError(NO_USER_PROFILE_IS_AUTHENTICATED)
    }

    @Test
    fun `When a user is authenticated, Then should return the userProfile as JSON`() {
        whenever(oneginiSdk.oneginiClient.userClient.authenticatedUserProfile).thenReturn(UserProfile("QWERTY"))

        getAuthenticatedUserProfileUseCase(resultSpy)

        val expectedResult = Gson().toJson(mapOf("profileId" to "QWERTY"))
        
        verify(resultSpy).success(eq(expectedResult))
    }
}