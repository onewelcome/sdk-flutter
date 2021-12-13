package com.onegini.mobile.sdk.flutter.helpers

import io.flutter.plugin.common.EventChannel

class OneginiEventsSender {
    var events: EventChannel.EventSink? = null

    fun setEventSink(eventSink: EventChannel.EventSink?) {
        if (eventSink != null)
            events = eventSink
    }

    var events: EventChannel.EventSink? = null

    fun setEventSink(eventSink: EventChannel.EventSink?) {
        if (eventSink != null)
            events = eventSink
    }
}
