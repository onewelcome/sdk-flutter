import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {

    public func authenticateDeviceForResource(_ scopes: [String], callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toResourceFetchHandler.authenticateDevice(scopes) {
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
            Logger.log("super path1 \(path)")
            Logger.log("super params1 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchResourceWithImplicitResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getAnonymousResource:
            Logger.log("super path2 \(path)")
            Logger.log("super params2 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchAnonymousResource(path, parameters: parameters, completion: callback)
        case Constants.Routes.getResource:
            Logger.log("super path3 \(path)")
            Logger.log("super params3 \(parameters)")
            bridgeConnector.toResourceFetchHandler.fetchSimpleResources(path, parameters: parameters, completion: callback)
        case Constants.Routes.getUnauthenticatedResource:
            Logger.log("super path4 \(path)")
            Logger.log("super params4 \(parameters)")
            bridgeConnector.toResourceFetchHandler.unauthenticatedRequest(path, parameters: parameters, callback: callback)
        default:
            callback(SdkError.convertToFlutter(SdkError(customType: .incrorrectResourcesAccess)))
        }
    }
}

