package com.onegini.mobile.sdk.flutter.module

import android.content.Context
import com.onegini.mobile.sdk.flutter.pigeonPlugin.NativeCallFlutterApi
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
class FlutterOneWelcomeSdkModule(private val applicationContext: Context, private val nativeApi: NativeCallFlutterApi) {

  @Provides
  @Singleton
  fun provideContext() = applicationContext

  @Provides
  @Singleton
  fun provideNativeApi() = nativeApi
}
