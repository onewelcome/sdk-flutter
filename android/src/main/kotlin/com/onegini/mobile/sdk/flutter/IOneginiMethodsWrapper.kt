package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import io.flutter.plugin.common.MethodChannel

interface IOneginiMethodsWrapper  {
 fun registerUser(identityProviderId:String?,scopes:String?,result: MethodChannel.Result,oneginiClient: OneginiClient)
}