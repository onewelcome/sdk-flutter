//
//  NewPinConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 20/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol PinConnectorProtocol {
    func registerPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func authorizePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancelPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    var pinReceiver: PinReceiverProtocol? { get set }
}

protocol PinReceiverProtocol: class {
    func receivePin(pin: String?)
    func cancelPinAction()
}

class NewPinConnector: NSObject, PinConnectorProtocol {
    var pinReceiver: PinReceiverProtocol?
    
    func registerPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func authorizePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func cancelPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
}
