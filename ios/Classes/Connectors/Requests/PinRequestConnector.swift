//
//  PinRequestConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 24/04/2021.
//

import Foundation

protocol PinRequestConnectorProtocol {
    func addListener(listener: PinListener)
    func removeListener(listener: PinListener)
    
    func acceptPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

protocol PinListener: class {
    func acceptPin(pin: String)
    func denyPin()
}

class PinRequestConnector: PinRequestConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var pinListeners: [PinListener] = []
    
    func addListener(listener: PinListener) {
        pinListeners.append(listener)
    }
    
    func removeListener(listener: PinListener) {
        let index = pinListeners.firstIndex { (element) -> Bool in
            return element === listener
        }
        
        if let i = index {
            pinListeners.remove(at: i)
        }
    }
    
    func acceptPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var pin: String?
        
        if let arg = call.arguments as! [String: Any]? {
            pin = arg[Constants.Parameters.pin] as? String
        }
        
        guard let p = pin else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .invalidArguments))
            result(nil)
            return
        }
        
        pinListeners.forEach { (listener) in
            listener.acceptPin(pin: p)
        }
        
        result(nil)
    }
    
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        pinListeners.forEach { (listener) in
            listener.denyPin()
        }
        
        result(nil)
    }
}
