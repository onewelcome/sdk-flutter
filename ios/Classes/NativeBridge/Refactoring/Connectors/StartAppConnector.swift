//
//  StartAppConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol StartAppConnectorProtocol: class {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class StartAppConnector: StartAppConnectorProtocol {
    var startAppWrapper: StartAppWrapperProtocol!
    
    init(wrapper: StartAppWrapperProtocol? = nil) {
        self.startAppWrapper = wrapper ?? StartAppWrapper()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var connectionTimeout: Int?

        if let arguments = call.arguments as! [String: Any]? {
        
            connectionTimeout = arguments[Constants.Parameters.connectionTimeout] as! Int?
        }
        
        self.startAppWrapper.startApp(timeInterval: connectionTimeout, callback: { [weak self] (success, error) in
            
            if let error = error {
                result(PluginError.from(data: error))
                return
            }
            
            guard success else {
                result(PluginError.from(customType: .newSomethingWentWrong))
                return
            }
            
            let data = self?.convert(profiles: self!.startAppWrapper.userProfiles())
            result(data)
        })
    }
    
    private func convert(profiles: [ONGUserProfile]) -> String {
        let value: [[String: String?]] = profiles.compactMap({ [Constants.Parameters.profileId: $0.profileId] })

        let data = String.stringify(json: value)
        return data
    }
}

protocol StartAppWrapperProtocol {
    func startApp(timeInterval: Int?, callback: @escaping (Bool, Error?) -> Void)
    func userProfiles() -> [ONGUserProfile]
}

class StartAppWrapper: StartAppWrapperProtocol {
    func startApp(timeInterval: Int?, callback: @escaping (Bool, Error?) -> Void) {
        if let timeInterval = timeInterval {
            ONGClientBuilder().setHttpRequestTimeout(TimeInterval(timeInterval))
        }
        
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start { (value, error) in
            callback(value, error)
        }
    }
    
    func userProfiles() -> [ONGUserProfile] {
        let profiles = ONGUserClient.sharedInstance().userProfiles()
        return Array(profiles)
    }
}
