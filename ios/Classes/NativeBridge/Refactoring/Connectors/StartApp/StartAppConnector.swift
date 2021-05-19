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

protocol StartAppConnectorProtocol: AnyObject {
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class StartAppConnector: StartAppConnectorProtocol {
    var startAppWrapper: StartAppWrapperProtocol
    
    init(wrapper: StartAppWrapperProtocol? = nil) {
        self.startAppWrapper = wrapper ?? StartAppWrapper()
    }
    
    deinit {
        print("deinit")
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var connectionTimeout: Int?

        if let arguments = call.arguments as! [String: Any]? {
            connectionTimeout = arguments[Constants.Parameters.connectionTimeout] as! Int?
        }
        
        self.startAppWrapper.startApp(timeInterval: connectionTimeout, callback: { [weak self] (success, error) in
            
            guard let weakSelf = self else { return } // In this case what has to be returned?
            
            if let error = error {
                result(FlutterError.from(error: error))
                return
            }
            
            guard success else {
                result(FlutterError.from(customType: .newSomethingWentWrong))
                return
            }
            
            let data = weakSelf.convert(profiles: weakSelf.startAppWrapper.userProfiles())
            result(data)
        })
    }
    
    private func convert(profiles: [ONGUserProfile]) -> String {
        let value: [[String: String?]] = profiles.compactMap({ [Constants.Parameters.profileId: $0.profileId] })

        let data = String.stringify(json: value)
        return data
    }
}
