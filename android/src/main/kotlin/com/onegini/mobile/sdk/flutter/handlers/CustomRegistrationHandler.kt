package com.onegini.mobile.sdk.flutter.handlers

import com.onegini.mobile.sdk.flutter.providers.CustomRegistrationAction
import java.lang.Exception

class CustomRegistrationHandler {
    fun actionRespondSuccess(
        idProvider: String?,
        customRegistrationActions: ArrayList<CustomRegistrationAction>,
        token: String?) {
        val action = getCustomRegistrationAction(idProvider, customRegistrationActions)

        when {
            action != null ->  action.returnSuccess(token)
            else -> return // TODO throw platform exception no provider found with that id once error rework is merged
         }
    }

    fun actionRespondError(
        idProvider: String?,
        customRegistrationActions: ArrayList<CustomRegistrationAction>,
        error: String?) {
        if (error == null) {
            // TODO Thow platform exception
            return
        }

        val action = getCustomRegistrationAction(idProvider, customRegistrationActions)

        when {
            action != null ->  action.returnError(Exception(error))
            else -> return // TODO throw platform exception
        }
    }

    private fun getCustomRegistrationAction(idProvider: String?, customRegistrationActions: ArrayList<CustomRegistrationAction>): CustomRegistrationAction? {
        if (idProvider == null) return null

        customRegistrationActions.forEach {
            if (it.getIdProvider() == idProvider) {
                return it
            }
        }

        return null
    }


}