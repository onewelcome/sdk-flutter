package com.onegini.mobile.sdk.flutter.useCases

import com.onegini.mobile.sdk.android.handlers.OneginiPendingMobileAuthWithPushRequestsHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPendingMobileAuthWithPushRequestError
import com.onegini.mobile.sdk.android.model.entity.OneginiMobileAuthWithPushRequest
import com.onegini.mobile.sdk.flutter.OneginiSDK
import com.onegini.mobile.sdk.flutter.helpers.SdkError
import com.onegini.mobile.sdk.flutter.pigeonPlugin.OWPendingMobileAuthRequest
import javax.inject.Inject

class GetPendingMobileAuthWithPushRequestsUseCase @Inject constructor(private val oneginiSDK: OneginiSDK) {
  operator fun invoke(callback: (Result<List<OWPendingMobileAuthRequest>>) -> Unit) {

    oneginiSDK.oneginiClient.userClient.getPendingMobileAuthWithPushRequests(object : OneginiPendingMobileAuthWithPushRequestsHandler {
      override fun onSuccess(mobileAuthWithPushRequests: MutableSet<OneginiMobileAuthWithPushRequest>) {
        callback(
          Result.success(mobileAuthWithPushRequests.map { item ->
            OWPendingMobileAuthRequest(
              transactionId = item.transactionId,
              userProfileId = item.userProfileId,
              date = item.timestamp,
              timeToLive = item.timeToLiveSeconds.toLong(),
              message = item.message,
            )
          }.toList())
        )
      }

      override fun onError(error: OneginiPendingMobileAuthWithPushRequestError) {
        callback(
          Result.failure(SdkError(error.errorType, error.message).pigeonError())
        )
      }
    })
  }
}
