package com.onegini.mobile.sdk

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneginiWrapperErrors
import com.onegini.mobile.sdk.flutter.useCases.GetAppToWebSingleSignOnUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAppToWebSingleSignOnUseCaseTests {
    @Mock
    lateinit var clientMock: OneginiClient

    @Mock
    lateinit var userClientMock: UserClient

    @Mock
    lateinit var oneginiAppToWebSingleSignOnError: OneginiAppToWebSingleSignOnError

    @Mock
    lateinit var oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn

    @Spy
    lateinit var resultSpy: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Before
    fun attach() {
        whenever(clientMock.userClient).thenReturn(userClientMock)
    }

    @Test
    fun `should return error when given parameter url is null`() {
        GetAppToWebSingleSignOnUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.URL_CANT_BE_NULL.code, OneginiWrapperErrors.URL_CANT_BE_NULL.message, null)
    }

    @Test
    fun `should return error when given parameter url is now web url`() {
        whenever(callMock.argument<String>("url")).thenReturn("test")

        GetAppToWebSingleSignOnUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.code, OneginiWrapperErrors.URL_IS_NOT_WEB_PATH.message, null)
    }

    @Test
    fun `should return error when SDK return error`() {
        whenever(callMock.argument<String>("url")).thenReturn("https://login-mobile.test.onegini.com/personal/dashboard")
        whenever(oneginiAppToWebSingleSignOnError.errorType).thenReturn(OneginiAppToWebSingleSignOnError.GENERAL_ERROR)
        whenever(oneginiAppToWebSingleSignOnError.message).thenReturn("General error")
        whenever(userClientMock.getAppToWebSingleSignOn(eq(Uri.parse("https://login-mobile.test.onegini.com/personal/dashboard")), any())).thenAnswer {
            it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onError(oneginiAppToWebSingleSignOnError)
        }

        GetAppToWebSingleSignOnUseCase(clientMock)(callMock, resultSpy)

        verify(resultSpy).error(oneginiAppToWebSingleSignOnError.errorType.toString(), oneginiAppToWebSingleSignOnError.message, null)
    }

    @Test
    fun `should return OneginiAppToWebSingleSignOn when SDK return success`() {
        whenever(callMock.argument<String>("url")).thenReturn("https://login-mobile.test.onegini.com/personal/dashboard")
        whenever(oneginiAppToWebSingleSignOn.redirectUrl).thenReturn(Uri.parse("http://www.test.com"))
        whenever(oneginiAppToWebSingleSignOn.token).thenReturn("token")
        whenever(userClientMock.getAppToWebSingleSignOn(eq(Uri.parse("https://login-mobile.test.onegini.com/personal/dashboard")), any())).thenAnswer {
            it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onSuccess(oneginiAppToWebSingleSignOn)
        }

        GetAppToWebSingleSignOnUseCase(clientMock)(callMock, resultSpy)

        val expectedResult = Gson().toJson(mapOf("token" to oneginiAppToWebSingleSignOn.token, "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl.toString()))
        verify(resultSpy).success(expectedResult)
    }


}