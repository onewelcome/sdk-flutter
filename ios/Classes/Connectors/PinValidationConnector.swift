//
//  PinValidationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 20/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol PinValidationConnectorProtocol {
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class PinValidationConnector: NSObject, PinValidationConnectorProtocol {
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var pin: String?
        
        if let arg = call.arguments as! [String: Any]? {
            pin = arg[Constants.Parameters.pin] as? String
        }
        
        guard pin != nil else {
            result(SdkError.init(customType: .invalidArguments))
            return;
        }
        
        OneginiModuleSwift.sharedInstance.validatePinWithPolicy(pin!, callback: result)
    }
}
