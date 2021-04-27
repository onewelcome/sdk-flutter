package com.onegini.mobile.sdk

import android.content.Context
import android.content.Intent
import com.google.common.truth.Truth
import com.onegini.mobile.sdk.flutter.useCases.HandleRegisteredUrlUseCase
import io.flutter.plugin.common.MethodCall
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argumentCaptor
import org.mockito.kotlin.whenever


/*
 I don`t know if we need tests for this class because Intent always null
 */

@RunWith(MockitoJUnitRunner::class)
class HandleRegisteredUrlUseCaseTests {

    @Mock
    lateinit var callMock: MethodCall

    @Mock
    lateinit var contextMock: Context

    @Test
    fun `should intent be null with url as a param when given url is null`() {
        whenever(callMock.argument<String>("url")).thenReturn(null)
        HandleRegisteredUrlUseCase()(callMock, contextMock)
        argumentCaptor<Intent> {
            Mockito.verify(contextMock).startActivity(capture())
            Truth.assertThat(firstValue.data).isEqualTo(null)
        }
    }

    @Test
    fun `should intent be null with url as a param when given url is not web link`() {
        whenever(callMock.argument<String>("url")).thenReturn("test")
        HandleRegisteredUrlUseCase()(callMock, contextMock)
        argumentCaptor<Intent> {
            Mockito.verify(contextMock).startActivity(capture())
            Truth.assertThat(firstValue.data).isEqualTo(null)
        }
    }

//    @Test
//    fun `should intent be not null with url as a param when given url is a web link`() {
//        whenever(callMock.argument<String>("url")).thenReturn("https://token-mobile.test.onegini.com/oauth/authorize?response_type=code&prompt=login&client_id=D9CB558D9137F4EE58DB3138B6E101EC03CB728E4B5D025393D9EABF94C1B731&redirect_uri=oneginiexample://loginsuccess&language=en&scope=read&state=EEB136D7-DEDC-42E0-A9CF-4A6E73BED902-122")
//        HandleRegisteredUrlUseCase()(callMock, contextMock)
//        argumentCaptor<Intent> {
//            Mockito.verify(contextMock).startActivity(capture())
//            Truth.assertThat(firstValue.data).isEqualTo()
//        }
//    }
}