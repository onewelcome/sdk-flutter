package com.onegini.mobile.sdk.flutter.helpers

import io.flutter.plugin.common.EventChannel

class OneginiEventsSender {
    companion object {
        var events: EventChannel.EventSink? = null

        fun setEventSink(eventSink: EventChannel.EventSink?) {
            if (eventSink != null)
                events = eventSink
        }
    }
}
