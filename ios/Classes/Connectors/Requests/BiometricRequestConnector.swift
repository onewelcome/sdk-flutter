//
//  BiometricRequestConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 24/04/2021.
//

import Foundation

protocol BiometricRequestConnectorProtocol {
    func addListener(listener: BiometricListener)
    func removeListener(listener: BiometricListener)
    
    func acceptBiometric(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyBiometric(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func fallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

protocol BiometricListener: class {
    func acceptBiometric(prompt: String)
    func fallbackToPin()
    func denyBiometric()
}

class BiometricRequestConnector: BiometricRequestConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var bioListeners: [BiometricListener] = []
    
    func addListener(listener: BiometricListener) {
        bioListeners.append(listener)
    }
    
    func removeListener(listener: BiometricListener) {
        let index = bioListeners.firstIndex { (element) -> Bool in
            return element === listener
        }
        
        if let i = index {
            bioListeners.remove(at: i)
        }
    }
    
    func acceptBiometric(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var prompt: String?
        
        if let arg = call.arguments as! [String: Any]? {
            prompt = arg[Constants.Parameters.prompt] as? String
        }
        
        guard let p = prompt else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .invalidArguments))
            result(nil)
            return
        }
        
        bioListeners.forEach { (listener) in
            listener.acceptBiometric(prompt: p)
        }
        
        result(nil)
    }
    
    func denyBiometric(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        bioListeners.forEach { (listener) in
            listener.denyBiometric()
        }
        
        result(nil)
    }
    
    func fallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        bioListeners.forEach { (listener) in
            listener.fallbackToPin()
        }
        
        result(nil)
    }
}
