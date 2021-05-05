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
        var customIdentityProviderIds: String?
        var connectionTimeout: Int?
        
        if let arguments = call.arguments as! [String: Any]? {
            customIdentityProviderIds = arguments[Constants.Parameters.twoStepCustomIdentityProviderIds] as! String?
            connectionTimeout = arguments[Constants.Parameters.connectionTimeout] as! Int?
        }
        
        let listIDs = startAppWrapper.splitInputCustomRegIDsValue(customIdentityProviderIds)
        self.startAppWrapper.configureCustomRegistrationIDs(listIDs)
        
        self.startAppWrapper.startApp(timeInterval: connectionTimeout, callback: { [weak self] (success, error) in
            
            if let error = error {
                result(PluginError.from(data: error))
                return
            }
            
            guard success else {
                result(PluginError.from(customType: .newSomethingWentWrong))
                return
            }
            
            let data = self?.startAppWrapper.userProfilesData()
            result(data)
        })
    }
}

protocol StartAppWrapperProtocol {
    func startApp(timeInterval: Int?, callback: @escaping (Bool, Error?) -> Void)
    func configureCustomRegistrationIDs(_ list: [String])
    func splitInputCustomRegIDsValue(_ value: String?) -> [String]
    func userProfilesData() -> String
}

class StartAppWrapper: StartAppWrapperProtocol {
    public var customRegistrationIDs = [String]()
    
    func startApp(timeInterval: Int?, callback: @escaping (Bool, Error?) -> Void) {
        if let timeInterval = timeInterval {
            ONGClientBuilder().setHttpRequestTimeout(TimeInterval(timeInterval))
        }
        
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
        return ids
    }
    
    func configureCustomRegistrationIDs(_ list: [String]) {
        self.customRegistrationIDs = list
    }
    
    func userProfilesData() -> String {
        let profiles = ONGUserClient.sharedInstance().userProfiles()
        let value: [[String: String?]] = profiles.compactMap({ [Constants.Parameters.profileId: $0.profileId] })

        let data = String.stringify(json: value)
        return data
    }
}
