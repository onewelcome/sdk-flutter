package com.onegini.plugin.onegini.handlers

import android.content.Context
import android.util.Log
import android.widget.Toast
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.R
import com.onegini.plugin.onegini.constants.Constants.Companion.EVENT_CLOSE_PIN
import com.onegini.plugin.onegini.constants.Constants.Companion.EVENT_OPEN_PIN
import com.onegini.plugin.onegini.constants.Constants.Companion.EVENT_OPEN_PIN_CONFIRMATION
import com.onegini.plugin.onegini.helpers.OneginiEventsSender
import java.util.*


class CreatePinRequestHandler(private var context: Context) : OneginiCreatePinRequestHandler {

    companion object {
        var CALLBACK: PinWithConfirmationHandler? = null

    }


    override fun startPinCreation(userProfile: UserProfile?, oneginiPinCallback: OneginiPinCallback?, pinLength: Int) {
        CALLBACK = PinWithConfirmationHandler(oneginiPinCallback)


        OneginiEventsSender.events?.success(EVENT_OPEN_PIN)
        /**
         * call [onPinPrivided] when you get pin code.
         * Now it`s harcoded.
         *
         */
    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError?) {
        OneginiEventsSender.events?.error(oneginiPinValidationError?.errorType.toString(),oneginiPinValidationError?.message, oneginiPinValidationError?.errorDetails)
    }

    override fun finishPinCreation() {
        OneginiEventsSender.events?.success(EVENT_CLOSE_PIN)
    }

    inner class PinWithConfirmationHandler(private val originalHandler: OneginiPinCallback?) {

        private var _pin: CharArray? = null

        fun onPinProvided(pin: CharArray?) {
            if (isPinSet) {
                secondPinProvided(pin)
            } else {
                firstPinProvided(pin)
            }
        }

        private fun firstPinProvided(pin: CharArray?) {
            OneginiSDK.getOneginiClient(context)?.userClient?.validatePinWithPolicy(pin, object : OneginiPinValidationHandler {
                override fun onSuccess() {
                    Log.v("PIN", "FIRST PIN")
                    _pin = pin
                    OneginiEventsSender.events?.success(EVENT_CLOSE_PIN)
                    OneginiEventsSender.events?.success(EVENT_OPEN_PIN_CONFIRMATION)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    handlePinValidationError(oneginiPinValidationError)
                }
            })
        }


        private fun secondPinProvided(pin: CharArray?) {
            Log.v("PIN", "SECOND PIN")
            val pinsEqual: Boolean = Arrays.equals(_pin, pin)
            if (pinsEqual) {
                /**
                 * [acceptAuthenticationRequest] method for accept pin and end registration/logIn flow
                 * If all ok callback will be in [RegistrationHelper.registerUser] (MainActivity) in onSuccess method.
                 */
                originalHandler?.acceptAuthenticationRequest(pin)
                nullifyPinArray()
            } else {
                OneginiEventsSender.events?.error("", context.getString(R.string.pin_error_not_equal), null)
            }
        }

        fun pinCancelled() {
            nullifyPinArray()
            originalHandler?.denyAuthenticationRequest()
        }

        private val isPinSet: Boolean
            get() = _pin != null

        private fun nullifyPinArray() {
            if (isPinSet) {
                val arraySize = _pin?.size
                if (arraySize != null && _pin != null)
                    for (i in 0 until arraySize) {
                        _pin!![i] = '\u0000'
                    }
                _pin = null
            }
        }

       private fun handlePinValidationError(oneginiPinValidationError: OneginiPinValidationError) {
            when (oneginiPinValidationError.errorType) {
                OneginiPinValidationError.WRONG_PIN_LENGTH -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), context.getString(R.string.pin_error_invalid_length), oneginiPinValidationError.cause)
                OneginiPinValidationError.PIN_BLACKLISTED -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), context.getString(R.string.pin_error_blacklisted), oneginiPinValidationError.cause)
                OneginiPinValidationError.PIN_IS_A_SEQUENCE -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), context.getString(R.string.pin_error_sequence), oneginiPinValidationError.cause)
                OneginiPinValidationError.PIN_USES_SIMILAR_DIGITS -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), context.getString(R.string.pin_error_similar), oneginiPinValidationError.cause)
                OneginiPinValidationError.DEVICE_DEREGISTERED -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message, oneginiPinValidationError.cause)
                OneginiPinValidationError.GENERAL_ERROR -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), context.getString(R.string.pin_error_invalid_length), oneginiPinValidationError.cause)
                else -> OneginiEventsSender.events?.error(oneginiPinValidationError.errorType.toString(), oneginiPinValidationError.message, oneginiPinValidationError.cause)
            }
        }

    }


}
