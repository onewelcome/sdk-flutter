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

    public func resourceRequest(isImplicit: Bool, isAnonymousCall: Bool = true, parameters: [String: Any],
                                callback: @escaping (Any?, FlutterError?) -> Void) {

        bridgeConnector.toResourceFetchHandler.resourceRequest(isImplicit: isImplicit, isAnonymousCall: isAnonymousCall, parameters: parameters, completion: {
            (data, error) -> Void in
            callback(data, error?.flutterError())
        })
    }
    
    public func fetchResources(_ path: String, type: String, parameters: [String: Any?], callback: @escaping FlutterResult) {
        switch type {
        case Constants.Routes.getImplicitResource:
            print("super path1 \(path)")
            print("super params1 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchResourceWithImplicitResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getResourceAnonymous:
            print("super path2 \(path)")
            print("super params2 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchAnonymousResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getResource:
            print("super path3 \(path)")
            print("super params3 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchSimpleResources(path, parameters: parameters, completion: callback)
        default:
            callback(SdkError.convertToFlutter(SdkError(customType: .incrorrectResourcesAccess)))
        }
    }
}

