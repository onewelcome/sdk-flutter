//
//  StartAppConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 19/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol StartAppConnectorProtocol: FlutterNotificationReceiverProtocol {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func reset(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class StartAppConnector: NSObject, StartAppConnectorProtocol {
    unowned var flutterConnector: FlutterConnectorProtocol?
    var wrapper: StartAppWrapperProtocol
    
    init(startAppWrapper: StartAppWrapperProtocol) {
        wrapper = startAppWrapper
        super.init()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        wrapper.startApp { (success, error) in
            if let error = error {
                result(error)
                return
            }
            
            result(success)
        }
    }
    
    func reset(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        wrapper.reset{ (success, error) in
            if let error = error {
                result(error)
                return
            }
            
            result(success)
        }
    }
    
}
