import Foundation
import OneginiSDKiOS
import Flutter

protocol DisconnectConnectorProtocol {
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func logoutUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class DisconnectConnector: DisconnectConnectorProtocol {
    private(set) var disconnectWrapper: DisconnectWrapperrProtocol
    
    init(wrapper: DisconnectWrapperrProtocol? = nil) {
        self.disconnectWrapper = wrapper ?? DisconnectWrapper()
    }
    
    func logoutUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        guard let _ = self.disconnectWrapper.authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        self.disconnectWrapper.logoutUser { (_, error) in
            guard let error = error else {
                result(true)
                return
            }
            
            result(FlutterError.from(error: error))
        }
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let authenticatedProfile = self.disconnectWrapper.authenticatedUserProfile() else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }
        
        self.disconnectWrapper.deregisterUser(authenticatedProfile) { (_, error) in
            guard let error = error else {
                result(true)
                return
            }
            
            result(FlutterError.from(error: error))
        }
    }
}
