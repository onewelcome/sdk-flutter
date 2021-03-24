import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {

    public func authenticateDeviceForResource(_ path: String, callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toResourceFetchHandler.authenticateDevice(path) {
            (data, error) -> Void in
            error != nil ? callback(error?.flutterError()) : callback(data)
        }
    }

    public func resourceRequest(_ isImplicit: Bool, parameters: [String: Any],
                                callback: @escaping (Any?, FlutterError?) -> Void) {

        bridgeConnector.toResourceFetchHandler.resourceRequest(isImplicit: isImplicit, parameters: parameters, completion: {
            (data, error) -> Void in
            callback(data, error?.flutterError())
        })
    }
    
    public func fetchResources(_ path: String, type: String, parameters: [String: Any?], callback: @escaping FlutterResult) {
        switch type {
        case Constants.Routes.getImplicitResource:
            bridgeConnector.toResourceFetchHandler.fetchResourceWithImplicitResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getResource:
            bridgeConnector.toResourceFetchHandler.fetchAnonymousResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getResourceAnonymous:
            bridgeConnector.toResourceFetchHandler.fetchSimpleResources(path, parameters: parameters, completion: callback)
        default:
            callback(SdkError.convertToFlutter(SdkError(customType: .incrorrectResourcesAccess)))
        }
    }
}

