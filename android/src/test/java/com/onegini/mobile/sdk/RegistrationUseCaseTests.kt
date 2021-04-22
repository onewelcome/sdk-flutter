package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.client.UserClient
import com.onegini.mobile.sdk.android.handlers.OneginiRegistrationHandler
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import com.onegini.mobile.sdk.android.model.entity.CustomInfo
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.mobile.sdk.flutter.useCases.RegistrationUseCase
import com.onegini.mobile.sdk.utils.OnegeniProviderTest
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.ArgumentMatchers.any
import org.mockito.Mock
import org.mockito.Mockito.verify
import org.mockito.Spy
import org.mockito.junit.MockitoJUnitRunner
import org.mockito.kotlin.argThat
import org.mockito.kotlin.times
import org.mockito.kotlin.whenever


@RunWith(MockitoJUnitRunner::class)
class RegistrationUseCaseTests {

    @Mock
    lateinit var client: OneginiClient

    @Mock
    lateinit var userClient: UserClient

    @Spy
    lateinit var mockResult: MethodChannel.Result

    @Mock
    lateinit var call : MethodCall

    @Before
    fun attach() {
        whenever(client.userClient).thenReturn(userClient)
    }

    @Test
    fun `Registration going by web and is successfully without identity provider`(){
        whenever(call.argument<String>("identityProviderId")).thenReturn(null)
        whenever(call.argument<String>("scopes")).thenReturn("read")
        whenever(userClient.registerUser(any(), any(), any())).thenAnswer{
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }
        RegistrationUseCase(client)(call, mockResult)
        verify(mockResult).success("QWERTY")
    }

    @Test
    fun `Registration going with right identity provider`(){
        val set = mutableSetOf<OneginiIdentityProvider>()
        set.add(OnegeniProviderTest())
        whenever(call.argument<String>("identityProviderId")).thenReturn("test provider id")
        whenever(call.argument<String>("scopes")).thenReturn("read")
        whenever(userClient.identityProviders).thenReturn(set)
        RegistrationUseCase(client)(call, mockResult)
        verify(client.userClient).registerUser(argThat { x -> x.id == OnegeniProviderTest().id }, any(), any())
    }



    @Test
    fun `Registration going with found identity provider and successfully`(){
        val set = mutableSetOf<OneginiIdentityProvider>()
        set.add(OnegeniProviderTest())
        whenever(call.argument<String>("identityProviderId")).thenReturn("test provider id")
        whenever(call.argument<String>("scopes")).thenReturn("read")
        whenever(userClient.identityProviders).thenReturn(set)
        whenever(userClient.registerUser(any(), any(), any())).thenAnswer{
            it.getArgument<OneginiRegistrationHandler>(2).onSuccess(UserProfile("QWERTY"), CustomInfo(0, ""))
        }
        RegistrationUseCase(client)(call, mockResult)
        verify(mockResult).success("QWERTY")
    }

    @Test
    fun `test if SDK called 'registerUser' method once`(){
        whenever(call.argument<String>("identityProviderId")).thenReturn(null)
        whenever(call.argument<String>("scopes")).thenReturn("read")
        RegistrationUseCase(client)(call, mockResult)
        verify(client.userClient, times(1)).registerUser(any(), any(), any())
    }

}