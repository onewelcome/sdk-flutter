package com.onegini.mobile.sdk

import android.content.Context
import com.google.common.truth.Truth.assertThat
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiInitializationError
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.models.Config
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.*


@RunWith(MockitoJUnitRunner::class)
class StartAppUseCaseTests {

    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var callMock: MethodCall

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var oneginiSDKMock: OneginiSDK

    @Mock
    lateinit var contextMock: Context

    @Mock
    lateinit var oneginiInitializationError: OneginiInitializationError

    @Before
    fun attach() {
        whenever(oneginiSDKMock.getOneginiClient()).thenReturn(clientMock)
    }

    @Test
    fun `should return UserProfile when start method returns single UserProfile`() {
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(setOf(UserProfile("QWERTY")))
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        val expectedList = setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"))
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return error when when start method returns error`() {
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onError(oneginiInitializationError)
        }
        whenever(oneginiInitializationError.errorType).thenReturn(OneginiInitializationError.GENERAL_ERROR)
        whenever(oneginiInitializationError.message).thenReturn("General error")

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiInitializationError.errorType.toString(), oneginiInitializationError.message, null)
    }

    @Test
    fun `should return set of UserProfiles when start method returns set with UserProfiles`() {
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(setOf(UserProfile("QWERTY"), UserProfile("ASDFGH")))
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        val expectedList = setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"), mapOf("isDefault" to false, "profileId" to "ASDFGH"))
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return empty set when start method returns empty set`() {
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        val expectedList = emptySet<UserProfile>()
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should properly pass oneginiCustomIdentityProviderList param to the SDK when list contains two items`() {
        whenever(callMock.argument<ArrayList<String>>("twoStepCustomIdentityProviderIds")).thenReturn(arrayListOf("id1", "id2"))
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        argumentCaptor<List<OneginiCustomIdentityProvider>> {
            verify(oneginiSDKMock).buildSDK(eq(contextMock), capture(), any(), eq(resultSpy))
            assertThat(firstValue.size).isEqualTo(2)
            assertThat(firstValue[0].id).isEqualTo("id1")
            assertThat(firstValue[1].id).isEqualTo("id2")
        }
    }

    @Test
    fun `should properly pass oneginiCustomIdentityProviderList param to the SDK when list contains one item`() {
        whenever(callMock.argument<ArrayList<String>>("twoStepCustomIdentityProviderIds")).thenReturn(arrayListOf("id1"))
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        argumentCaptor<List<OneginiCustomIdentityProvider>> {
            verify(oneginiSDKMock).buildSDK(eq(contextMock), capture(), any(), eq(resultSpy))
            assertThat(firstValue.size).isEqualTo(1)
            assertThat(firstValue[0].id).isEqualTo("id1")
        }
    }
    
    @Test
    fun `should properly pass connectionTimeout and readTimeout params to the SDK when provided`() {
        whenever(callMock.argument<Int>("connectionTimeout")).thenReturn(5)
        whenever(callMock.argument<Int>("readTimeout")).thenReturn(20)
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSDKMock).buildSDK(eq(contextMock), eq(mutableListOf()), capture(), eq(resultSpy))
            assertThat(firstValue.httpConnectionTimeout).isEqualTo(5)
            assertThat(firstValue.httpReadTimeout).isEqualTo(20)
        }
    }

    @Test
    fun `should properly pass securityControllerClassName and configModelClassName params to the SDK when provided`() {
        whenever(callMock.argument<String>("securityControllerClassName")).thenReturn("com.onegini.mobile.onegini_example.SecurityController")
        whenever(callMock.argument<String>("configModelClassName")).thenReturn("com.onegini.mobile.onegini_example.OneginiConfigModel")
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSDKMock).buildSDK(eq(contextMock), eq(mutableListOf()), capture(), eq(resultSpy))
            assertThat(firstValue.configModelClassName).isEqualTo("com.onegini.mobile.onegini_example.OneginiConfigModel")
            assertThat(firstValue.securityControllerClassName).isEqualTo("com.onegini.mobile.onegini_example.SecurityController")
        }
    }

    @Test
    fun `should properly pass connectionTimeout and readTimeout params with zero values to the SDK when provided`() {
        whenever(callMock.argument<Int>("connectionTimeout")).thenReturn(0)
        whenever(callMock.argument<Int>("readTimeout")).thenReturn(0)
        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }

        StartAppUseCase(contextMock, oneginiSDKMock)(callMock, resultSpy)

        argumentCaptor<Config> {
            verify(oneginiSDKMock).buildSDK(eq(contextMock), eq(mutableListOf()), capture(), eq(resultSpy))
            assertThat(firstValue.httpConnectionTimeout).isEqualTo(0)
            assertThat(firstValue.httpReadTimeout).isEqualTo(0)
        }
    }
}