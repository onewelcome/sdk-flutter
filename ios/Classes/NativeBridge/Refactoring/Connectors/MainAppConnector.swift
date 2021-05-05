//
//  MainAppConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation

class MainAppConnector {
    private(set) var startAppConnector: StartAppConnectorProtocol!
    
    init(startAppConnector: StartAppConnectorProtocol? = nil) {
        self.startAppConnector = startAppConnector ?? StartAppConnector()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        startAppConnector?.startApp(call, result)
    }
}
