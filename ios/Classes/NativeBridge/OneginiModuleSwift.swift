import Foundation
import OneginiSDKiOS
import Flutter

public class OneginiModuleSwift: NSObject {
 
    var bridgeConnector: BridgeConnector
    public var customRegIdentifiers = [String]()    
    static public let sharedInstance = OneginiModuleSwift()
    
    override init() {
        self.bridgeConnector = BridgeConnector()
        super.init()
    }
    
    func configureCustomRegIdentifiers(_ list: [String]) {
        self.customRegIdentifiers = list
    }
    
    func startOneginiModule(httpConnectionTimeout: TimeInterval = TimeInterval(5), callback: @escaping FlutterResult) {
        ONGClientBuilder().setHttpRequestTimeout(httpConnectionTimeout)
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start {
          result, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                callback(mappedError.flutterError())
                return
            }
            
            if !result {
                callback(SdkError(.genericError).flutterError())
                return
            }
            
            let profiles = ONGUserClient.sharedInstance().userProfiles()
            let value: [[String: String?]] = profiles.compactMap({ ["profileId": $0.profileId] })

            let data = String.stringify(json: value)
            
            callback(data)
        }
    }
    
    func getUserProfiles() -> Result<[OWUserProfile], FlutterError> {
        let profiles = ONGUserClient.sharedInstance().userProfiles()
        return .success(profiles.compactMap { OWUserProfile($0) } )
    }
}

