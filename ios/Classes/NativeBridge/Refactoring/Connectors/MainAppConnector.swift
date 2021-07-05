//
//  MainAppConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation

class MainAppConnector {
    private(set) var startAppConnector: StartAppConnectorProtocol!
    private(set) var registerUserConnector: RegisterUserConnectorProtocol!
    
    init(startAppConnector: StartAppConnectorProtocol? = nil,
         regusterUserConnector: RegisterUserConnectorProtocol? = nil) {
        self.startAppConnector = startAppConnector ?? StartAppConnector()
        self.registerUserConnector = regusterUserConnector ?? RegisterUserConnector()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        startAppConnector?.startApp(call, result)
    }
    
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.registerUserConnector.registerUser(call, result)
    }
    
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.registerUserConnector.handleRegisteredProcessUrl(call, result)
    }
    
    func cancelRegistrationProcess(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.registerUserConnector.cancel(call, result)
    }
}
