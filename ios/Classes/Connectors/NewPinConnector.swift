//
//  NewPinConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 20/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol PinConnectorProtocol: FlutterNotificationReceiverProtocol {
    func registerPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func authorizePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancelPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    var pinReceiver: PinReceiverProtocol? { get set }
}

protocol PinReceiverProtocol: class {
    func receivePin(pin: String?)
}

class NewPinConnector: NSObject, PinConnectorProtocol {
    
    var wrapper: PinWrapperProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    unowned var pinReceiver: PinReceiverProtocol?
    
    init(pinWrapper: PinWrapperProtocol) {
        wrapper = pinWrapper
        super.init()
        
        wrapper.notificationReceiver = self
    }
    
    func registerPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func authorizePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func cancelPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
}

extension NewPinConnector: NewPinNotificationReceiverProtocol {
    func sendNotification(event: NewPinNotification, eventData: Any?, error: SdkError?) {
        if let error = error {
            var data: [String: Any?] = [:]
            data[Constants.Parameters.eventName] = RegistrationNotification.eventError.rawValue
            data[Constants.Parameters.eventValue] = error.toJSON()
            
            flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: String.stringify(json: data))
        } else {
            var data: [String: Any?] = [:]
            data[Constants.Parameters.eventName] = event.rawValue
            if let eventData = eventData {
                data[Constants.Parameters.eventValue] = String.stringify(json: eventData)
            }
            
            flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: data)
        }
    }
}
