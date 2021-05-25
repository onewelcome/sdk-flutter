import Foundation
import OneginiSDKiOS
import Flutter

protocol UserProfilesConnectorProtocol {
    func fetchUserProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class UserProfilesConnector: UserProfilesConnectorProtocol {
    private(set) var userProfilestWrapper: UserProfilesWrapperProtocol
    
    init(wrapper: UserProfilesWrapperProtocol = UserProfilesWrapper()) {
        self.userProfilestWrapper = wrapper
    }
    
    func fetchUserProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        Logger.log("fetchUserProfiles", sender: self)
        let list = self.userProfilestWrapper.userProfiles()
        let data = String.stringify(json: list.toDict())
        result(data)
    }
}

extension Array where Element == ONGUserProfile {
    func toDict() -> [[String: String?]] {
        let jsonData = self.compactMap({ return [Constants.Parameters.profileId: $0.profileId]})
        return jsonData
    }
}

