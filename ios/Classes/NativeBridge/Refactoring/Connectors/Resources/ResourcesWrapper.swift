import Foundation
import OneginiSDKiOS
import Flutter

typealias ResourcesCallbackResult = (ONGResourceResponse?, Error?) -> Void
typealias ResourcesCallbackSuccess = (Bool, Error?) -> Void

//MARK: ResourcesWrapperProtocol
protocol ResourcesWrapperProtocol {
    func unauthenticatedRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult)
    func anonymousRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult)
    func implicitRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult)
    func authenticatedRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult)
    func authenticateDevice(scopes: [String], callback: @escaping ResourcesCallbackSuccess)
    func authenticateImplicitly(profile: ONGUserProfile, scopes: [String]?, completion: @escaping ResourcesCallbackSuccess)
    func authenticatedUserProfile() -> ONGUserProfile?
}

//MARK: ResourcesWrapperProtocol
class ResourcesWrapper: ResourcesWrapperProtocol {
    func unauthenticatedRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult) {
        Logger.log("UnauthenticatedRequest", sender: self)
        ONGDeviceClient.sharedInstance().fetchUnauthenticatedResource(request, completion: callback)
    }
    
    func authenticateDevice(scopes: [String], callback: @escaping ResourcesCallbackSuccess) {
        Logger.log("AuthenticateDevice", sender: self)
        ONGDeviceClient.sharedInstance().authenticateDevice(scopes, completion: callback)
    }
    
    func anonymousRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult) {
        Logger.log("AonymousRequest", sender: self)
        ONGDeviceClient.sharedInstance().fetchResource(request, completion: callback)
    }
    
    func authenticatedRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult) {
        Logger.log("AuthenticatedRequest", sender: self)
        ONGUserClient.sharedInstance().fetchResource(request, completion: callback)
    }
    
    func implicitRequest(_ request: ONGResourceRequest, parameters: [String: Any], callback: @escaping ResourcesCallbackResult) {
        Logger.log("ImplicitRequest", sender: self)
        ONGUserClient.sharedInstance().fetchImplicitResource(request, completion: callback)
    }
    
    func authenticateImplicitly(profile: ONGUserProfile, scopes: [String]?, completion: @escaping ResourcesCallbackSuccess) {
        Logger.log("AuthenticateProfileImplicitly", sender: self)
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: scopes, completion: completion)
    }
    
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
}
