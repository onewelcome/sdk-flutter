//
//  StartAppWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 19/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol StartAppWrapperProtocol {
    func startApp(completion: @escaping (Bool, SdkError?) -> Void)
    func reset(completion: @escaping (Bool, SdkError?) -> Void)
}

// MARK: Wrapper
class StartAppWrapper: NSObject, StartAppWrapperProtocol {
    func startApp(completion: @escaping (Bool, SdkError?) -> Void) {
        let builder = ONGClientBuilder().build()
        builder.start { (success, error) in
            if success {
                completion(true, nil)
            } else {
                if let error = error {
                    completion(false, SdkError.init(errorDescription: error.localizedDescription, code: error.code))
                } else {
                    completion(false, SdkError.init(customType: .newSomethingWentWrong))
                }
            }
        }
    }
    
    func reset(completion: @escaping (Bool, SdkError?) -> Void) {
        ONGClient.sharedInstance().reset { (success, error) in
            if success {
                completion(true, nil)
            } else {
                if let error = error {
                    completion(false, SdkError.init(errorDescription: error.localizedDescription, code: error.code))
                } else {
                    completion(false, SdkError.init(customType: .newSomethingWentWrong))
                }
            }
        }
    }
}
