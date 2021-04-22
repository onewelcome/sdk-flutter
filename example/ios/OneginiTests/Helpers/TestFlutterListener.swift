//
//  TestFlutterListener.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 22/04/2021.
//

@testable import onegini

class TestFlutterListener: FlutterConnectorProtocol {
    var receiveEvent: ((OneginiBridgeEvents, Any) -> Void)?
    
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) {
        receiveEvent?(eventName, data as Any)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
