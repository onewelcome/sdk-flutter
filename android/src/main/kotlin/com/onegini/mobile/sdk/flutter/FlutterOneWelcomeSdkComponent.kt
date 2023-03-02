package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.flutter.module.FlutterOneWelcomeSdkModule
import dagger.Component
import javax.inject.Singleton

@Component(modules = [FlutterOneWelcomeSdkModule::class])
@Singleton
interface FlutterOneWelcomeSdkComponent {

  fun inject(oneginiPlugin: OneginiPlugin)
}
