import Foundation
import OneginiSDKiOS

typealias StartAppCallbackResult = (Bool, Error?) -> Void

protocol StartAppWrapperProtocol {
    func startApp(timeInterval: Int?, callback: @escaping StartAppCallbackResult)
    func userProfiles() -> [ONGUserProfile]
}

class StartAppWrapper: StartAppWrapperProtocol {
    func startApp(timeInterval: Int?, callback: @escaping StartAppCallbackResult) {
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
