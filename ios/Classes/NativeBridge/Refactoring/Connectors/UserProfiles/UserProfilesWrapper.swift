import OneginiSDKiOS
import Flutter

protocol UserProfilesWrapperProtocol {
    func userProfiles() -> Array<ONGUserProfile>
}

class UserProfilesWrapper: UserProfilesWrapperProtocol {
    func userProfiles() -> Array<ONGUserProfile> {
        return Array(ONGUserClient.sharedInstance().userProfiles())
    }
}

