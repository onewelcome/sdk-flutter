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
    
    func startOneginiModule(httpConnectionTimeout: Int64?, callback: @escaping (Result<Void, FlutterError>) -> Void) {
        if let httpConnectionTimeout = httpConnectionTimeout {
            ONGClientBuilder().setHttpRequestTimeout(TimeInterval(Double(httpConnectionTimeout)))
        } else {
            ONGClientBuilder().setHttpRequestTimeout(TimeInterval(5))
        }
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start {
          result, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                callback(.failure(mappedError.flutterError()))
                return
            }
            
            if !result {
                callback(.failure(SdkError(.genericError).flutterError()))
                return
            }
            callback(.success)
        }
    }
    
    func getUserProfiles() -> Result<[OWUserProfile], FlutterError> {
        let profiles = ONGUserClient.sharedInstance().userProfiles()
        return .success(profiles.compactMap { OWUserProfile($0) } )
    }
}

