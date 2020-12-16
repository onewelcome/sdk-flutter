package com.onegini.plugin.onegini_example

import io.flutter.plugin.common.EventChannel

class EventStorage {
    companion object{
        var events: EventChannel.EventSink? = null

        fun setEventSink(eventSink: EventChannel.EventSink?){
            if(eventSink!=null)
                events = eventSink
        }

    }
}