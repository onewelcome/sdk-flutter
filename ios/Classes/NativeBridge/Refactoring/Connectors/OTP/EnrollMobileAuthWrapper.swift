import Foundation
import OneginiSDKiOS

typealias OTPCallbackSuccess = (Bool, Error?) -> Void

protocol EnrollMobileAuthWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func isUserEnrolledForMobileAuth(profile: ONGUserProfile?) -> Bool
    func enroll(forMobileAuth completion: @escaping OTPCallbackSuccess) -> Void
}

class EnrollMobileAuthWrapper: EnrollMobileAuthWrapperProtocol {
    //MARK: Methods
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func isUserEnrolledForMobileAuth(profile: ONGUserProfile?) -> Bool {
        guard let userProfile = profile else {
            return false
        }

        return ONGUserClient.sharedInstance().isUserEnrolled(forMobileAuth: userProfile)
    }
    
    func enroll(forMobileAuth completion: @escaping OTPCallbackSuccess) {
        ONGUserClient.sharedInstance().enroll(forMobileAuth: completion)
    }
}
