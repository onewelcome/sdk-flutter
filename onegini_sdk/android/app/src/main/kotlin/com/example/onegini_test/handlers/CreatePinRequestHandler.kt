package com.example.onegini_test.handlers

import android.content.Context
import com.example.onegini_test.OneginiSDK
import com.example.onegini_test.RegistrationHelper
import com.onegini.mobile.sdk.android.handlers.OneginiPinValidationHandler
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError
import com.onegini.mobile.sdk.android.handlers.error.OneginiPinValidationError.PinValidationErrorType
import com.onegini.mobile.sdk.android.handlers.request.OneginiCreatePinRequestHandler
import com.onegini.mobile.sdk.android.handlers.request.callback.OneginiPinCallback
import com.onegini.mobile.sdk.android.model.entity.UserProfile
import java.util.*


class CreatePinRequestHandler(var context: Context?) : OneginiCreatePinRequestHandler{

    companion object{
        var CALLBACK: PinWithConfirmationHandler? = null

    }


    override fun startPinCreation(userProfile : UserProfile?, oneginiPinCallback : OneginiPinCallback?, pinLength: Int) {
        CALLBACK = PinWithConfirmationHandler(oneginiPinCallback!!,context)

        /**
         * call [onPinPrivided] when you get pin code.
         * Now it`s harcoded.
         * 
         */
        CALLBACK?.onPinProvided(charArrayOf('5','5','6','6','7'))

    }

    override fun onNextPinCreationAttempt(oneginiPinValidationError: OneginiPinValidationError?) {
        //todo return error when pin not valid
    }

    override fun finishPinCreation() {
          //todo have no idea what must be here
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
                    PinWithConfirmationHandler.pin = pin
                    secondPinProvided(pin)
                }

                override fun onError(oneginiPinValidationError: OneginiPinValidationError) {
                    handlePinValidationError(oneginiPinValidationError)
                }
            })
        }

        
        private fun secondPinProvided(pin: CharArray?) {
            val pinsEqual: Boolean = Arrays.equals(PinWithConfirmationHandler.pin, pin)
            nullifyPinArray()
            if (pinsEqual) {
                /**
                 * [acceptAuthenticationRequest] method for accept pin and end registration/logIn flow
                 * If all ok callback will be in [RegistrationHelper.registerUser] (MainActivity) in onSuccess method.
                 */
                originalHandler.acceptAuthenticationRequest(pin)
            } else {
               //todo somehow return error to Flatter page
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
            @PinValidationErrorType val errorType = oneginiPinValidationError.errorType
            //todo somehow return error to Flatter page (Maybe should use another methodChanel with streams for errors)
//            when (errorType) {
//                OneginiPinValidationError.WRONG_PIN_LENGTH -> notifyOnError(context?.getString(R.string.pin_error_invalid_length))
//                OneginiPinValidationError.PIN_BLACKLISTED -> notifyOnError(context?.getString(R.string.pin_error_blacklisted))
//                OneginiPinValidationError.PIN_IS_A_SEQUENCE -> notifyOnError(context?.getString(R.string.pin_error_sequence))
//                OneginiPinValidationError.PIN_USES_SIMILAR_DIGITS -> notifyOnError(context?.getString(R.string.pin_error_similar))
//                // OneginiPinValidationError.DEVICE_DEREGISTERED -> DeregistrationUtil(context).onDeviceDeregistered()
//                OneginiPinValidationError.GENERAL_ERROR -> notifyOnError(oneginiPinValidationError.message)
//                else -> notifyOnError(oneginiPinValidationError.message)
//            }
        }

    }


}
