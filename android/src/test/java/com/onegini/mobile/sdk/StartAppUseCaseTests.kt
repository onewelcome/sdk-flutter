package com.onegini.mobile.sdk

import com.google.common.truth.Truth.assertThat
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.models.CustomIdentityProviderConfig
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner

import org.mockito.kotlin.*

@RunWith(MockitoJUnitRunner::class)
class StartAppUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var oneginiInitializationError: OneginiInitializationError

    lateinit var startAppUseCase: StartAppUseCase
    @Before
    fun attach() {
        startAppUseCase = StartAppUseCase(oneginiSdk)
    }

    @Test
    fun `should return UserProfile when start method returns single UserProfile`() {
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(setOf(UserProfile("QWERTY")))
        }

        startAppUseCase(callMock, resultSpy)

        val expectedList = setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"))
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return error when when start method returns error`() {
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onError(oneginiInitializationError)
        }
        whenever(oneginiInitializationError.errorType).thenReturn(OneginiInitializationError.GENERAL_ERROR)
        whenever(oneginiInitializationError.message).thenReturn("General error")

        startAppUseCase(callMock, resultSpy)

        val message = oneginiInitializationError.message
        verify(resultSpy).error(eq(oneginiInitializationError.errorType.toString()), eq(message), any())
    }

    @Test
    fun `should return set of UserProfiles when start method returns set with UserProfiles`() {
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(setOf(UserProfile("QWERTY"), UserProfile("ASDFGH")))
        }

        startAppUseCase(callMock, resultSpy)

        val expectedList = setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"), mapOf("isDefault" to false, "profileId" to "ASDFGH"))
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return empty set when start method returns empty set`() {
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        val expectedList = emptySet<UserProfile>()
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should properly pass customIdentityProviderConfigs JSON string list within the config to the SDK when list contains two items`() {
        whenever(callMock.argument<ArrayList<String>>("customIdentityProviderConfigs"))
            .thenReturn(arrayListOf(Gson().toJson(CustomIdentityProviderConfig("id1", false)),
                Gson().toJson(CustomIdentityProviderConfig("id2", true))))
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSdk).buildSDK(capture(), eq(resultSpy))
            assertThat(firstValue.customIdentityProviderConfigs.size).isEqualTo(2)
            assertThat(firstValue.customIdentityProviderConfigs[0].providerId).isEqualTo("id1")
            assertThat(firstValue.customIdentityProviderConfigs[0].isTwoStep).isEqualTo(false)
            assertThat(firstValue.customIdentityProviderConfigs[1].providerId).isEqualTo("id2")
            assertThat(firstValue.customIdentityProviderConfigs[1].isTwoStep).isEqualTo(true)
        }
    }

    @Test
    fun `should properly pass customIdentityProviderConfigs JSON string list within the config to the SDK when list contains one item`() {
        whenever(callMock.argument<ArrayList<String>>("customIdentityProviderConfigs"))
            .thenReturn(arrayListOf(Gson().toJson(CustomIdentityProviderConfig("id1", false))))
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSdk).buildSDK(capture(), eq(resultSpy))
            assertThat(firstValue.customIdentityProviderConfigs.size).isEqualTo(1)
            assertThat(firstValue.customIdentityProviderConfigs[0].providerId).isEqualTo("id1")
            assertThat(firstValue.customIdentityProviderConfigs[0].isTwoStep).isEqualTo(false)
        }
    }
    
    @Test
    fun `should properly pass connectionTimeout and readTimeout params to the SDK when provided`() {
        whenever(callMock.argument<Int>("connectionTimeout")).thenReturn(5)
        whenever(callMock.argument<Int>("readTimeout")).thenReturn(20)
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSdk).buildSDK(capture(), eq(resultSpy))
            assertThat(firstValue.httpConnectionTimeout).isEqualTo(5)
            assertThat(firstValue.httpReadTimeout).isEqualTo(20)
        }
    }

    @Test
    fun `should properly pass securityControllerClassName and configModelClassName params to the SDK when provided`() {
        whenever(callMock.argument<String>("securityControllerClassName")).thenReturn("com.onegini.mobile.onegini_example.SecurityController")
        whenever(callMock.argument<String>("configModelClassName")).thenReturn("com.onegini.mobile.onegini_example.OneginiConfigModel")
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSdk).buildSDK(capture(), eq(resultSpy))
            assertThat(firstValue.configModelClassName).isEqualTo("com.onegini.mobile.onegini_example.OneginiConfigModel")
            assertThat(firstValue.securityControllerClassName).isEqualTo("com.onegini.mobile.onegini_example.SecurityController")
        }
    }

    @Test
    fun `should properly pass connectionTimeout and readTimeout params with zero values to the SDK when provided`() {
        whenever(callMock.argument<Int>("connectionTimeout")).thenReturn(0)
        whenever(callMock.argument<Int>("readTimeout")).thenReturn(0)
        whenever(oneginiSdk.oneginiClient.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        startAppUseCase(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSdk).buildSDK(capture(), eq(resultSpy))
            assertThat(firstValue.httpConnectionTimeout).isEqualTo(0)
            assertThat(firstValue.httpReadTimeout).isEqualTo(0)
        }
    }
}
