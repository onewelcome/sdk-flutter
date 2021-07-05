//
//  PinConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
import OneginiSDKiOS

//MARK: - PinConnectorProtocol
protocol PinConnectorProtocol: class {
    func acceptPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func configure(wrapper pinWrapper: PinWrapperProtocol?)
}

//MARK: - PinWrapperProtocol
protocol PinWrapperProtocol: class {
    func acceptPin(pin: String)
    func denyPin()
}

//MARK: - PinConnector
class NewPinConnector: PinConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    weak var delegatePinWrapper: PinWrapperProtocol? = nil
    
    //MARK: PinConnectorProtocol
    func configure(wrapper pinWrapper: PinWrapperProtocol?) {
        self.delegatePinWrapper = pinWrapper
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
        
        self.delegatePinWrapper?.acceptPin(pin: p)

        result(nil)
    }
    
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        self.delegatePinWrapper?.denyPin()
        
        result(nil)
    }
}
