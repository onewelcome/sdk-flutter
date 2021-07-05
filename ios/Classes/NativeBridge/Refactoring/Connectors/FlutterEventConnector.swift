//
//  FlutterEventConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
import OneginiSDKiOS

protocol FlutterNotificationReceiverProtocol {
    var flutterConnector: FlutterConnectorProtocol? { get set }
}

protocol FlutterConnectorProtocol: class {
    func sendBridgeEvent(eventName: OneginiPluginEvents, data: Any?) -> Void
}

class FlutterConnector: FlutterConnectorProtocol, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    public var eventSinkNativePart: FlutterEventSink?
    public var eventSinkCustomIdentifier: String?
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let value = eventSinkCustomIdentifier, let arguments = arguments as! String?, value == arguments {
            self.eventSinkNativePart = events
        } else if let arguments = arguments as! String?, arguments == "onegini_events" {
            eventSink = events
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func sendBridgeEvent(eventName: OneginiPluginEvents, data: Any?) {
        //Logger.log("event name: \(eventName)", sender: self, logType: .log)
        eventSink?(data)
    }
}


