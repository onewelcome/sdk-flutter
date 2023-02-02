import Foundation
import OneginiSDKiOS
import OneginiCrypto

//MARK: -
protocol MobileAuthConnectorToHandlerProtocol: AnyObject {
    func enrollForMobileAuth(_ completion: @escaping (Bool?, SdkError?) -> Void)
    func isUserEnrolledForMobileAuth() -> Bool
    func handleMobileAuthConfirmation(cancelled: Bool)
    func handleOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void)
    func handleQrOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void)
}

protocol MobileAuthNotificationReceiverProtocol: class {
    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?)
}

enum MobileAuthAuthenticatorType: String {
    case fingerprint = "biometric"
    case pin = "PIN"
    case confirmation = ""
}

//MARK: -
class MobileAuthHandler: NSObject {
    var userProfile: ONGUserProfile?
    var message: String?
    var authenticatorType: MobileAuthAuthenticatorType?
    var confirmation: ((Bool) -> Void)?
    var mobileAuthCompletion: ((Any?, SdkError?) -> Void)?
    
    unowned var notificationReceiver: MobileAuthNotificationReceiverProtocol?
    
    fileprivate func handleConfirmationMobileAuth(_ cancelled: Bool) {
        guard let confirmation = confirmation else { fatalError() }
        
        confirmation(cancelled)
    }
    
    private func sendConnectorNotification(_ event: MobileAuthNotification, _ requestMessage: String?, _ error: SdkError?) {
        notificationReceiver?.sendNotification(event: event, requestMessage: requestMessage, error: error)
    }
}

//MARK: - MobileAuthConnectorToHandlerProtocol
extension MobileAuthHandler : MobileAuthConnectorToHandlerProtocol {
    func enrollForMobileAuth(_ completion: @escaping (Bool?, SdkError?) -> Void) {
        ONGClient.sharedInstance().userClient.enroll { enrolled, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error);
                completion(false, mappedError)
              } else {
                if(enrolled == false){
                    completion(false, SdkError(.enrollmentFailed))
                    return;
                }
                
                completion(true, nil)
              }
        }
    }
    
    func isUserEnrolledForMobileAuth() -> Bool {
        let userClient = ONGUserClient.sharedInstance()
        return isUserEnrolledForMobileAuth(userClient: userClient)
    }
    
    func isUserEnrolledForMobileAuth(userClient: ONGUserClient) -> Bool {
        if let userProfile = userClient.authenticatedUserProfile() {
            return userClient.isUserEnrolled(forMobileAuth: userProfile)
        }
        return false
    }
    
    func handleMobileAuthConfirmation(cancelled: Bool) {
        switch authenticatorType {
        case .confirmation:
            handleConfirmationMobileAuth(cancelled)
            break
        case .fingerprint, .pin:
            //@todo
            confirmation?(cancelled)
            break
        default:
            //@todo
            confirmation?(cancelled)
            break
        }
    }
    
    func handleOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void) {
        mobileAuthCompletion = completion
        
        guard let challenge = customRegistrationChallenge else {
            ONGUserClient.sharedInstance().handleOTPMobileAuthRequest(otp.base64Encoded() ?? "", delegate: self)
            return
        }
        
        challenge.sender.respond(withData: otp, challenge: challenge)
    }
    
    func handleQrOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void) {
        mobileAuthCompletion = completion
        guard ONGUserClient.sharedInstance().canHandleOTPMobileAuthRequest(otp) else {
            completion(false, SdkError(.cantHandleOTP))
            return
        }
        ONGUserClient.sharedInstance().handleOTPMobileAuthRequest(otp, delegate: self)
    }
}

//MARK: - ONGMobileAuthRequestDelegate
extension MobileAuthHandler: ONGMobileAuthRequestDelegate {
    func userClient(_: ONGUserClient, didReceiveConfirmationChallenge confirmation: @escaping (Bool) -> Void, for request: ONGMobileAuthRequest) {
        message = request.message
        userProfile = request.userProfile
        authenticatorType = .confirmation
        self.confirmation = confirmation
        mobileAuthCompletion?(request.message, nil)
        sendConnectorNotification(MobileAuthNotification.startAuthentication, request.message, nil)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge, for request: ONGMobileAuthRequest) {
       //@todo will need this for PUSH
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGBiometricChallenge, for request: ONGMobileAuthRequest) {
        //@todo will need this for PUSH
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge, for request: ONGMobileAuthRequest) {
        //@todo will need this for PUSH Custom
    }

    func userClient(_ userClient: ONGUserClient, didFailToHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            mobileAuthCompletion?(false, SdkError(.authenticationCancelled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            mobileAuthCompletion?(false, mappedError)
        }
    }

    func userClient(_ userClient: ONGUserClient, didHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, info customAuthenticatorInfo: ONGCustomInfo?) {
        mobileAuthCompletion?(message, nil)
    }
}
