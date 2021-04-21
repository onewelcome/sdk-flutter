//
//  StartAppWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 19/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol StartAppWrapperProtocol {
    func startApp(completion: @escaping (Bool, Error?) -> Void)
    func reset(completion: @escaping (Bool, Error?) -> Void)
}

// MARK: Wrapper
class StartAppWrapper: NSObject, StartAppWrapperProtocol {
    func startApp(completion: @escaping (Bool, Error?) -> Void) {
        let builder = ONGClientBuilder()
        let client = builder.build()
        client.start { (success, error) in
            completion(success, error)
        }
    }
    
    func reset(completion: @escaping (Bool, Error?) -> Void) {
        ONGClient.sharedInstance().reset { (success, error) in
            completion(success, error)
        }
    }
}
