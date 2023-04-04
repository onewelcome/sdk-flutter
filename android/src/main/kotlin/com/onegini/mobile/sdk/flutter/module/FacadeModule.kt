package com.onegini.mobile.sdk.flutter.module

import com.onegini.mobile.sdk.flutter.facade.UriFacade
import com.onegini.mobile.sdk.flutter.facade.UriFacadeImpl
import dagger.Binds
import dagger.Module

@Module
interface FacadeModule {
  @Binds
  fun bindUriFacade(uriFacade: UriFacadeImpl): UriFacade
}
