import Foundation
import OneginiSDKiOS

typealias OTPCallbackData = (String?, Error?) -> Void

protocol OTPWrapperProtocol {
    func handleMobileAuthConfirmation(cancelled: Bool)
    func canHandleOTP(_ otp: String) -> Bool
    func handleQrOTPMobileAuth(_ otp: String, customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping OTPCallbackData)
}

class OTPWrapper: NSObject, OTPWrapperProtocol {
    //MARK: Properties
    var message: String?
    var userProfile: ONGUserProfile?
    var confirmation: ((Bool) -> Void)?
    var mobileAuthCompletion: OTPCallbackData?
    
    //MARK: Methods
    func handleMobileAuthConfirmation(cancelled: Bool) {
        self.confirmation?(cancelled)
    }
    
    func canHandleOTP(_ otp: String) -> Bool {
        return ONGUserClient.sharedInstance().canHandleOTPMobileAuthRequest(otp)
    }
    
    func handleQrOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping OTPCallbackData) {
        mobileAuthCompletion = completion
        ONGUserClient.sharedInstance().handleOTPMobileAuthRequest(otp, delegate: self)
    }
}

//MARK: - ONGMobileAuthRequestDelegate
extension OTPWrapper: ONGMobileAuthRequestDelegate {
    func userClient(_: ONGUserClient, didReceiveConfirmationChallenge confirmation: @escaping (Bool) -> Void, for request: ONGMobileAuthRequest) {
        self.message = request.message
        self.userProfile = request.userProfile
        self.confirmation = confirmation
        
        mobileAuthCompletion?(request.message, nil)
        //sendConnectorNotification(MobileAuthNotification.startAuthentication, request.message, nil)
    }

    func userClient(_ userClient: ONGUserClient, didFailToHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, error: Error) {

        mobileAuthCompletion?(nil, error)
    }

    func userClient(_ userClient: ONGUserClient, didHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, info customAuthenticatorInfo: ONGCustomInfo?) {
        mobileAuthCompletion?(message, nil)
    }
}
