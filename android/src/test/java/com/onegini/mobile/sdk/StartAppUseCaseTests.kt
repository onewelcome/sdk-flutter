package com.onegini.mobile.sdk

import android.content.Context
import com.google.common.truth.Truth
import com.google.common.truth.Truth.assertThat
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.handlers.OneginiInitializationHandler
import com.onegini.mobile.sdk.android.model.OneginiCustomIdentityProvider
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.useCases.StartAppUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentMatchers
import org.mockito.Mock
import org.mockito.Mockito
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

    @Test
    fun `should return set of UserProfile when connection timeout is null, read timeout is null and list of identity providers is empty`() {
        whenever(oneginiSDKMock.initSDK(eq(contextMock), isNull(), isNull(), eq(mutableListOf()))).thenReturn(clientMock)

        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(setOf(UserProfile("QWERTY")))
        }
        StartAppUseCase()(callMock, resultSpy, contextMock, oneginiSDKMock)
        val expectedList = setOf(mapOf("isDefault" to false, "profileId" to "QWERTY"))
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `should return empty set when connection timeout is null, read timeout is null and list of identity providers is empty`() {
        whenever(oneginiSDKMock.initSDK(eq(contextMock), isNull(), isNull(), eq(mutableListOf()))).thenReturn(clientMock)

        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }
        StartAppUseCase()(callMock, resultSpy, contextMock, oneginiSDKMock)
        val expectedList = emptySet<UserProfile>()
        val expectedResult = Gson().toJson(expectedList)
        verify(resultSpy).success(expectedResult)
    }

    @Test
    fun `oneginiCustomIdentityProviderList should be not empty when twoStepCustomIdentityProviderIds is not empty`() {
        whenever(callMock.argument<ArrayList<String>>("twoStepCustomIdentityProviderIds")).thenReturn(arrayListOf("id1","id2"))

        whenever(oneginiSDKMock.initSDK(eq(contextMock), isNull(), isNull(), any())).thenReturn(clientMock)

        whenever(clientMock.start(any())).thenAnswer {
            it.getArgument<OneginiInitializationHandler>(0).onSuccess(emptySet())
        }
        StartAppUseCase()(callMock, resultSpy, contextMock, oneginiSDKMock)

        argumentCaptor<List<OneginiCustomIdentityProvider>> {
            verify(oneginiSDKMock).initSDK(eq(contextMock), isNull(), isNull(), capture())
            assertThat(firstValue.size).isEqualTo(2)
            assertThat(firstValue[0].id).isEqualTo("id1")
            assertThat(firstValue[1].id).isEqualTo("id2")
        }
    }

}