package com.onegini.mobile.sdk

import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiBrowserRegistrationCallback
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL
import com.onegini.mobile.sdk.flutter.SdkErrorAssert
import com.onegini.mobile.sdk.flutter.handlers.BrowserRegistrationRequestHandler
import com.onegini.mobile.sdk.flutter.useCases.CancelBrowserRegistrationUseCase
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mock
import org.mockito.junit.MockitoJUnitRunner

@RunWith(MockitoJUnitRunner::class)
class CancelBrowserRegistrationUseCaseTest {
  @Mock
  lateinit var oneginiBrowserCallbackMock: OneginiBrowserRegistrationCallback

  private lateinit var cancelBrowserRegistrationUseCase: CancelBrowserRegistrationUseCase

  @Before
  fun attach() {
    cancelBrowserRegistrationUseCase = CancelBrowserRegistrationUseCase()
  }

  @Test
  fun `When no browser registration callback is set, Then it should resolve with an error`() {
    BrowserRegistrationRequestHandler.callback = null

    val result = cancelBrowserRegistrationUseCase().exceptionOrNull()
    SdkErrorAssert.assertEquals(ACTION_NOT_ALLOWED_BROWSER_REGISTRATION_CANCEL, result)
  }

  @Test
  fun `When a pin browser registration callback is set, Then it should resolve successfully`() {
    BrowserRegistrationRequestHandler.callback = oneginiBrowserCallbackMock

    val result = cancelBrowserRegistrationUseCase().getOrNull()
    Assert.assertEquals(Unit, result)
  }
}
