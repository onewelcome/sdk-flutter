import Flutter
import Foundation
import OneginiSDKiOS

protocol DisconnectConnectorProtocol {
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
    func logoutUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class DisconnectConnector: DisconnectConnectorProtocol {
    private(set) var disconnectWrapper: DisconnectWrapperrProtocol

    init(wrapper: DisconnectWrapperrProtocol = DisconnectWrapper()) {
        disconnectWrapper = wrapper
    }

    func logoutUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("logoutUser", sender: self)
        guard disconnectWrapper.authenticatedUserProfile() != nil else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }

        disconnectWrapper.logoutUser { _, error in
            guard let error = error else {
                result(true)
                return
            }

            result(FlutterError.from(error: error))
        }
    }

    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("deregisterUser", sender: self)
        guard let arguments = call.arguments as? [String: Any], let userProfileId = arguments[Constants.Parameters.profileId] as? String else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }

        guard let userProfile = disconnectWrapper.userProfile(by: userProfileId) else {
            result(FlutterError.from(customType: .noUserAuthenticated))
            return
        }

        disconnectWrapper.deregisterUser(userProfile) { _, error in
            guard let error = error else {
                result(true)
                return
            }

            result(FlutterError.from(error: error))
        }
    }
}
