package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.FlutterError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OneWelcomeUserProfile
import com.onegini.mobile.sdk.flutter.pigeonPlugin.UserClientApi

open class PigeonInterface: UserClientApi {
  // Example function on how it could be initiated on Flutter send to Native
  override fun fetchUserProfiles(callback: (Result<List<OneWelcomeUserProfile>>) -> Unit) {
//        val a = Result.success(listOf(PigeonUserProfile("ghalo", true)))
//        val a = Result.failure<List<PigeonUserProfile>>(Exception("meee", Throwable("boop")))
//        callback(Result.failure(FlutterException(CODE, MESSAGE, DETAILS)))
    val b = mutableMapOf<String, String>()
    b["lol"] = "derp"

//    val c = Result.failure<List<OneWelcomeUserProfile>>(FlutterError("meee", "hallo", b)).exceptionOrNull()

//    callback(Result.failure(FlutterError("meee", "hallo", b)))



    val a = Result.success(listOf(OneWelcomeUserProfile("ghalo", true)))
    temp(callback, a)

//    temp(callback, Result.failure(SdkError(2000, "hallo")))
  }

  fun <T> temp(callback: (Result<T>)  -> Unit, result: Result<T>) {
    val potentialError = result.exceptionOrNull()
    val potentialValue = result.getOrNull()

    if (potentialError != null && potentialError is SdkError) {
      // error
      callback(Result.failure(FlutterError(potentialError.code.toString(), potentialError.message, potentialError.details)))
    } else if (potentialError != null) {
      // for different passed error
    } else if (result.isSuccess && potentialValue != null) {
      callback(Result.success(potentialValue))
    } else {
      // throw critical error
    }
  }
}