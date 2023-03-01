package com.onegini.mobile.sdk.flutter.module

import android.content.Context
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Module
class FlutterOneWelcomeSdkModule(private val applicationContext: Context) {

  @Provides
  @Singleton
  fun provideContext() = applicationContext
}
