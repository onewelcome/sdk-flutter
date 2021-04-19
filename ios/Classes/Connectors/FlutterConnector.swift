//
//  FlutterConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol FlutterConnectorProtocol: FlutterStreamHandler {
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

protocol FlutterNotificationReceiverProtocol {
    var flutterConnector: FlutterConnectorProtocol? { get set }
}

class FlutterConnector: NSObject, FlutterConnectorProtocol, FlutterStreamHandler {
    
    private var eventSink: FlutterEventSink?
    public var eventSinkNativePart: FlutterEventSink?
    public var eventSinkCustomIdentifier: String?
    
    override init() {
        super.init()
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let _value = eventSinkCustomIdentifier, let _arg = arguments as! String?, _value == _arg {
            self.eventSinkNativePart = events
        } else if let _arg = arguments as! String?, _arg == "onegini_events" {
            eventSink = events
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void {
        if eventName == OneginiBridgeEvents.otpOpen {
            eventSinkNativePart?(data)
            return;
        }
        
        eventSink?(data)
    }
}
