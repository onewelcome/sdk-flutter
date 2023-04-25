package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import org.junit.Assert
import javax.inject.Singleton

@Singleton
class SdkErrorAssert : Assert() {
  companion object {
    fun assertEquals(expected: OneWelcomeWrapperErrors, actual: Any?) {
      when (actual) {
        is FlutterError -> {
          assertEquals(expected.code, actual.code.toInt())
          assertEquals(expected.message, actual.message)
        }
        else -> fail(OneWelcomeWrapperErrors.UNEXPECTED_ERROR_TYPE.message)
      }
    }

    fun assertEquals(expected: FlutterError, actual: Any?) {
      when (actual) {
        is FlutterError -> {
          assertEquals(expected.code, actual.code)
          assertEquals(expected.message, actual.message)
        }
        else -> fail(OneWelcomeWrapperErrors.UNEXPECTED_ERROR_TYPE.message)
      }
    }
  }
}
