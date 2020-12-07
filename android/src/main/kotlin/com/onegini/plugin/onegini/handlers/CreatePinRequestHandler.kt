package com.onegini.plugin.onegini.handlers

import android.content.Context
import android.util.Log
import android.widget.Toast
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import com.onegini.plugin.onegini.Constants.Companion.EVENT_CLOSE_PIN
import com.onegini.plugin.onegini.Constants.Companion.EVENT_OPEN_PIN
import com.onegini.plugin.onegini.Constants.Companion.EVENT_OPEN_PIN_CONFIRMATION
import com.onegini.plugin.onegini.OneginiEventsSender
import com.onegini.plugin.onegini.OneginiSDK
import com.onegini.plugin.onegini.R
import com.onegini.plugin.onegini.util.DeregistrationUtil
import java.util.*


class CreatePinRequestHandler(private var context: Context?) : OneginiCreatePinRequestHandler{

    companion object{
        var CALLBACK: PinWithConfirmationHandler? = null

    }


    override fun startPinCreation(userProfile : UserProfile?, oneginiPinCallback : OneginiPinCallback?, pinLength: Int) {
        CALLBACK = PinWithConfirmationHandler(oneginiPinCallback!!,context)


        OneginiEventsSender.events?.success(EVENT_OPEN_PIN)
        /**
         * call [onPinPrivided] when you get pin code.
         * Now it`s harcoded.
         * 
         */
    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError?) {
        Toast.makeText(context,oneginiPinValidationError?.message, Toast.LENGTH_SHORT).show()
    }

    override fun finishPinCreation() {
        OneginiEventsSender.events?.success(EVENT_CLOSE_PIN)
    }

    class PinWithConfirmationHandler(private val originalHandler: OneginiPinCallback,private val context: Context?) {
        companion object{
            var pin: CharArray? = null
        }

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
                    Log.v("PIN","FIRST PIN")
                    PinWithConfirmationHandler.pin = pin
                    OneginiEventsSender.events?.success(EVENT_CLOSE_PIN)
                    OneginiEventsSender.events?.success(EVENT_OPEN_PIN_CONFIRMATION)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    handlePinValidationError(oneginiPinValidationError)
                }
            })
        }

        
        private fun secondPinProvided(pin: CharArray?) {
            Log.v("PIN","SECOND PIN")
            val pinsEqual: Boolean = Arrays.equals(PinWithConfirmationHandler.pin, pin)
            if (pinsEqual) {
                /**
                 * [acceptAuthenticationRequest] method for accept pin and end registration/logIn flow
                 * If all ok callback will be in [RegistrationHelper.registerUser] (MainActivity) in onSuccess method.
                 */
                originalHandler.acceptAuthenticationRequest(pin)
                nullifyPinArray()
            } else {
                Toast.makeText(context,context?.getString(R.string.pin_error_not_equal), Toast.LENGTH_SHORT).show()
            }
        }

        fun pinCancelled() {
            nullifyPinArray()
            originalHandler.denyAuthenticationRequest()
        }

        private val isPinSet: Boolean
            get() = pin != null

        private fun nullifyPinArray() {
            if (isPinSet) {
                val arraySize = pin!!.size
                for (i in 0 until arraySize) {
                    pin!![i] = '\u0000'
                }
                pin = null
            }
        }
        fun handlePinValidationError(oneginiPinValidationError: OneginiPinValidationError) {
            when (oneginiPinValidationError.errorType) {
                OneginiPinValidationError.WRONG_PIN_LENGTH ->  Toast.makeText(context,context?.getString(R.string.pin_error_invalid_length), Toast.LENGTH_SHORT).show()
                OneginiPinValidationError.PIN_BLACKLISTED ->Toast.makeText(context,context?.getString(R.string.pin_error_blacklisted), Toast.LENGTH_SHORT).show()
                OneginiPinValidationError.PIN_IS_A_SEQUENCE -> Toast.makeText(context,context?.getString(R.string.pin_error_sequence), Toast.LENGTH_SHORT).show()
                OneginiPinValidationError.PIN_USES_SIMILAR_DIGITS -> Toast.makeText(context,context?.getString(R.string.pin_error_similar), Toast.LENGTH_SHORT).show()
                OneginiPinValidationError.DEVICE_DEREGISTERED -> DeregistrationUtil(context!!).onDeviceDeregistered()
                OneginiPinValidationError.GENERAL_ERROR -> Toast.makeText(context,oneginiPinValidationError.message, Toast.LENGTH_SHORT).show()
                else -> Toast.makeText(context,oneginiPinValidationError.message, Toast.LENGTH_SHORT).show()
            }
        }

    }


}
