package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiRegistrationError
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.Mockito.`when`
import org.mockito.Mockito.verify
import org.mockito.MockitoAnnotations
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class RegistrationTests {

    @Mock
    lateinit var client: OneginiClient

    @Mock
    lateinit var userClient: UserClient

    @Mock
    lateinit var mockResult: MethodChannel.Result

    @Mock
    lateinit var call : MethodCall

    @Before
    fun attach() {
        MockitoAnnotations.initMocks(this)
        `when`(client.userClient).thenReturn(userClient)
    }

    @Test
    fun `registration test when provider is null`(){
        `when`(call.argument<String>("identityProviderId")).thenReturn(null)
        `when`(call.argument<String>("scopes")).thenReturn("read")
        `when`(userClient.registerUser(any(),any(), any())).thenAnswer{
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0,""))
        }
        RegistrationUseCase().invoke(call,client,mockResult)
        verify(mockResult).success("QWERTY")
    }
}