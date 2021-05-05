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

//FIXME: Refactoring
class StartAppConnector: StartAppConnectorProtocol {
    var startAppWrapper: StartAppWrapperProtocol?
    
    init(wrapper: StartAppWrapperProtocol? = nil) {
        self.startAppWrapper = wrapper ?? StartAppWrapper()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var customIdentityProviderIds: String?
        var connectionTimeout: Int?
        
        if let arguments = call.arguments as! [String: Any]? {
            customIdentityProviderIds = arguments[Constants.Parameters.twoStepCustomIdentityProviderIds] as! String?
            connectionTimeout = arguments[Constants.Parameters.connectionTimeout] as! Int?
        }
        
        
        
        let timeInterval = TimeInterval(connectionTimeout)
        ONGClientBuilder().setHttpRequestTimeout(timeInterval)
//        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
        
        startAppWrapper?.startApp(callback: { value,error in
            result(String.stringify(json: [String]()))
        })
    }
}

protocol StartAppWrapperProtocol {
    func startApp(timeInterval: Int? = nil, callback: @escaping (Bool, Error?) -> Void)
    func configureCustomRegistrationIDs(_ list: [String])
    func splitInputCustomRegIDsValue(_ value: String?) -> [String]
    func userProfiles()
}

class StartAppWrapper: StartAppWrapperProtocol {
    public var customRegistrationIDs = [String]()
    
    func startApp(timeInterval: Int? = nil, callback: @escaping (Bool, Error?) -> Void) {
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start { (value, error) in
            callback(value, error)
        }
    }
    
    func splitInputCustomRegIDsValue(_ value: String?) -> [String] {
        let customIdentityProviderIds = value ?? ""
        debugPrint("Providers: " + customIdentityProviderIds)
        guard customIdentityProviderIds.count > 0 else {
            return [String]()
        }
        let ids = customIdentityProviderIds.split(separator: ",").map {$0.trimmingCharacters(in: .whitespacesAndNewlines)}
            OneginiModuleSwift.sharedInstance.configureCustomRegIdentifiers(ids)
    }
    
    func configureCustomRegistrationIDs(_ list: [String]) {
        self.customRegistrationIDs = list
    }
    
    func userProfiles() {
        
    }
}
