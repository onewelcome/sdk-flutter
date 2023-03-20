import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    func authenticateDevice(_ scopes: [String]?, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toResourceFetchHandler.authenticateDevice(scopes, completion: completion)
    }

    func requestResource(_ type: ResourceRequestType, _ details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, FlutterError>) -> Void) {
        bridgeConnector.toResourceFetchHandler.requestResource(type, details, completion: completion)
    }
}
