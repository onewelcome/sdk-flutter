package com.onegini.mobile.sdk.flutter

import com.onegini.mobile.sdk.android.client.OneginiClient
import com.onegini.mobile.sdk.android.model.OneginiIdentityProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface IOneginiMethodsWrapper  {
 fun registerUser(call: MethodCall,result: MethodChannel.Result,oneginiClient: OneginiClient)
}