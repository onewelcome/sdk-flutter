package com.onegini.mobile.sdk

import android.net.Uri
import com.google.gson.Gson
import com.onegini.mobile.sdk.android.handlers.OneginiAppToWebSingleSignOnHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiAppToWebSingleSignOnError
import com.onegini.mobile.sdk.android.model.OneginiAppToWebSingleSignOn
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.*
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.useCases.GetAppToWebSingleSignOnUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import junit.framework.TestCase.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Answers
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.any
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.eq
import org.mockito.kotlin.verify
import org.mockito.kotlin.whenever

@RunWith(MockitoJUnitRunner::class)
class GetAppToWebSingleSignOnUseCaseTests {

    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    lateinit var oneginiSdk: OneginiSDK

    @Mock
    lateinit var resultMock: MethodChannel.Result

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    private lateinit var uriFacade: UriFacade

    // We need to deep stub here to mock a uri object's .toString() as we cant pass a uriFacade into the OneginiAppToWebSingleSignOn
    @Mock(answer = Answers.RETURNS_DEEP_STUBS)
    private lateinit var oneginiAppToWebSingleSignOn: OneginiAppToWebSingleSignOn

    @Mock
    private lateinit var oneginiAppToWebSingleSignOnError: OneginiAppToWebSingleSignOnError

    @Mock
    private lateinit var parsedUri: Uri

    private val correctUri = "https://login-mobile.test.onegini.com/personal/dashboard"
    private val mockedTokenString = "mockedToken"
    private val mockedRedirectUrlString = "mockedRedirectUrl"

    lateinit var getAppToWebSingleSignOnUseCase: GetAppToWebSingleSignOnUseCase
    @Before
    fun setup() {
        getAppToWebSingleSignOnUseCase = GetAppToWebSingleSignOnUseCase(oneginiSdk, uriFacade)
    }

    @Test
    fun `When GetAppToWebSingleSignOn is called without a url argument, Then should fail with URL_CANT_BE_NULL error`() {
        whenCalledWithNullUrl()

        getAppToWebSingleSignOnUseCase(callMock, resultMock)

        val message = URL_CANT_BE_NULL.message
        verify(resultMock).error(eq(URL_CANT_BE_NULL.code.toString()), eq(message), any())
    }

    @Test
    fun `When oginini getAppToWebSingleSignOn calls onSuccess on the handler, Then promise should resolve with a map containing the content from the result`() {
        whenCalledWithUrl()
        mockParseUri(correctUri)
        mockSingleSignOnObject()
        whenever(oneginiSdk.oneginiClient.userClient.getAppToWebSingleSignOn(any(), any())).thenAnswer {
            it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onSuccess(oneginiAppToWebSingleSignOn)
        }

        getAppToWebSingleSignOnUseCase(callMock, resultMock)

        val argumentCaptor = argumentCaptor<String>()
        verify(resultMock).success(argumentCaptor.capture())
        // This will be reworked after FP-20 when we actually send the objects
        val expectedResult = Gson().toJson(
            mapOf(
                "token" to oneginiAppToWebSingleSignOn.token,
                "redirectUrl" to oneginiAppToWebSingleSignOn.redirectUrl.toString()
            )
        )
        assertEquals(argumentCaptor.firstValue, expectedResult)

    }

    @Test
    fun `When oginini getAppToWebSingleSignOn calls onError on the handler, Then result should fail with the error message and code`() {
        mockParseUri(correctUri)
        whenCalledWithUrl()
        whenSSOReturnsError()

        getAppToWebSingleSignOnUseCase(callMock, resultMock)

        val message = oneginiAppToWebSingleSignOnError.message
        verify(resultMock).error(eq(oneginiAppToWebSingleSignOnError.errorType.toString()), eq(message), any())
    }



    private fun mockSingleSignOnObject() {
        whenever(oneginiAppToWebSingleSignOn.token).thenReturn(mockedTokenString)
        whenever(oneginiAppToWebSingleSignOn.redirectUrl.toString()).thenReturn(mockedRedirectUrlString)
    }

    private fun whenSSOReturnsError() {
        whenever(oneginiAppToWebSingleSignOnError.errorType).thenReturn(1000)
        whenever(oneginiAppToWebSingleSignOnError.message).thenReturn("message")
        whenever(oneginiSdk.oneginiClient.userClient.getAppToWebSingleSignOn(any(), any())).thenAnswer {
            it.getArgument<OneginiAppToWebSingleSignOnHandler>(1).onError(oneginiAppToWebSingleSignOnError)
        }
    }

    private fun mockParseUri(uri: String) {
        whenever(uriFacade.parse(uri)).thenReturn(parsedUri)
    }

    private fun whenCalledWithUrl() {
        whenever(callMock.argument<String>("url")).thenReturn(correctUri)
    }

    private fun whenCalledWithNullUrl() {
        whenever(callMock.argument<String>("url")).thenReturn(null)
    }

}