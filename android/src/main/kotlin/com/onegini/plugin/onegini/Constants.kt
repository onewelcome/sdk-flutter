package com.onegini.plugin.onegini

interface Constants {
    companion object {
        val DEFAULT_SCOPES = arrayOf("read")
        const val NEW_LINE = "\n"
        const val FCM_SENDER_ID = "586427927998"
        const val EXTRA_COMMAND = "command"
        const val COMMAND_START = "start"
        const val COMMAND_FINISH = "finish"
        const val COMMAND_SHOW_SCANNING = "show"
        const val COMMAND_RECEIVED_FINGERPRINT = "received"
        const val COMMAND_ASK_TO_ACCEPT_OR_DENY = "ask"
    }
}
