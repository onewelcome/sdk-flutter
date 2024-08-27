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

    func startOneginiModule(httpConnectionTimeout: Int64?, additionalResourceUrls: [String]?, callback: @escaping (Result<Void, FlutterError>) -> Void) {
        _ = ClientBuilder().setHttpRequestTimeout(TimeInterval(Double(httpConnectionTimeout ?? 5)))
        _ = ClientBuilder().setAdditionalResourceUrls(additionalResourceUrls ?? [])
        ClientBuilder().buildAndWaitForProtectedData { client in
            client.start { error in
                if let error = error {
                    let mappedError = ErrorMapper().mapError(error)
                    callback(.failure(mappedError.flutterError()))
                    return
                }
                callback(.success)
            }
        }
    }

    func getUserProfiles() -> Result<[OWUserProfile], FlutterError> {
        let profiles = SharedUserClient.instance.userProfiles
        return .success(profiles.compactMap { OWUserProfile($0) })
    }
}
