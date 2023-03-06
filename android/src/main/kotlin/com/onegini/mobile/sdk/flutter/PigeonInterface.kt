package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OneWelcomeUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi
import com.onegini.mobile.sdk.flutter.OneWelcomeWrapperErrors.GENERIC_ERROR

open class PigeonInterface: UserClientApi {
  // Example function on how it could be initiated on Flutter send to Native
  override fun fetchUserProfiles(callback: (Result<List<OneWelcomeUserProfile>>) -> Unit) {
    val a = Result.success(listOf(OneWelcomeUserProfile("ghalo", true)))
    flutterCallback(callback, a)

//    val b = Result.failure<List<OneWelcomeUserProfile>>(SdkError(2000, "hallo"))
//    flutterCallback(callback, b)
  }

  override fun voidFunction(callback: (Result<Unit>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun nullableStringFunction(callback: (Result<String?>) -> Unit) {
    TODO("Not yet implemented")
  }

  override fun nullableFetchUserProfiles(callback: (Result<List<OneWelcomeUserProfile>?>) -> Unit) {
    val a = Result.success(null)
    flutterCallback(callback, a)
  }

  private fun <T> flutterCallback(callback: (Result<T>)  -> Unit, result: Result<T>) {
    result.fold(
      onFailure = { error ->
        when (error) {
          is SdkError -> callback(Result.failure(error.pigeonError()))
          else -> callback(Result.failure(error))
        }
      },
      onSuccess = { value ->
        callback(Result.success(value))
      }
    )
  }
}