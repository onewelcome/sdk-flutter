import Foundation
import OneginiSDKiOS

protocol MobileAuthConnectorToHandlerProtocol: AnyObject {
    func handleMobileAuthWithOtp2(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func enrollForMobileAuth(_ completion: @escaping (Bool?, SdkError?) -> Void)
    func isUserEnrolledForMobileAuth() -> Bool
    func handleMobileAuthConfirmation(cancelled: Bool)
    func handleOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void)
    func handleQrOTPMobileAuth(_ otp: String , customRegistrationChallenge: ONGCustomRegistrationChallenge?, _ completion: @escaping (Any?, SdkError?) -> Void)
}

enum MobileAuthAuthenticatorType: String {
    case fingerprint = "biometric"
    case pin = "PIN"
    case confirmation = ""
}

class MobileAuthHandler: NSObject {
    var authenticatorType: MobileAuthAuthenticatorType?
    var confirmation: ((Bool) -> Void)?
    var mobileAuthCompletion: ((Any?, SdkError?) -> Void)?

    var mobileAuthCallback: ((Bool) -> Void)?
    var handleMobileAuthCompletion: ((Result<Void, FlutterError>) -> Void)?

    fileprivate func handleConfirmationMobileAuth(_ cancelled: Bool) {
        guard let confirmation = confirmation else { fatalError() }
        
        confirmation(cancelled)
    }
}

//MARK: - MobileAuthConnectorToHandlerProtocol
extension MobileAuthHandler : MobileAuthConnectorToHandlerProtocol {
    func handleMobileAuthWithOtp2(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("handleMobileAuthWithOtp", sender: self)
        handleMobileAuthCompletion = completion

        guard ONGUserClient.sharedInstance().canHandleOTPMobileAuthRequest(otp) else {
            handleMobileAuthCompletion = nil
            completion(.failure(FlutterError(SdkError(.cantHandleOTP))))
            return
        }

        ONGUserClient.sharedInstance().handleOTPMobileAuthRequest(otp, delegate: self)
    }

    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("enrollMobileAuthentication", sender: self)
        guard let _ = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }

        ONGClient.sharedInstance().userClient.enroll { enrolled, error in
            guard let error = error else {
                if enrolled == true {
                    completion(.success)
                } else {
                    completion(.failure(FlutterError(SdkError(.enrollmentFailed))))
                }

                return
            }

            let mappedError = ErrorMapper().mapError(error);
            completion(.failure(FlutterError(mappedError)))
        }
    }

    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("acceptMobileAuthRequest", sender: self)
        guard let callback = mobileAuthCallback else {
            completion(.failure(FlutterError(SdkError(.otpAuthenticationNotInProgress))))
            return
        }

        callback(true)
        mobileAuthCallback = nil
        completion(.success)
    }

    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("denyMobileAuthRequest", sender: self)
        guard let callback = mobileAuthCallback else {
            completion(.failure(FlutterError(SdkError(.otpAuthenticationNotInProgress))))
            return
        }

        callback(false)
        mobileAuthCallback = nil
        completion(.success)
    }

    // todo delete
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

    // todo delete
    func isUserEnrolledForMobileAuth() -> Bool {
        let userClient = ONGUserClient.sharedInstance()
        return isUserEnrolledForMobileAuth(userClient: userClient)
    }

    // delete
    func isUserEnrolledForMobileAuth(userClient: ONGUserClient) -> Bool {
        if let userProfile = userClient.authenticatedUserProfile() {
            return userClient.isUserEnrolled(forMobileAuth: userProfile)
        }
        return false
    }

    // delete; replaced for mobileAuthCompletion variable
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
//        authenticatorType = .confirmation
//        self.confirmation = confirmation
        
        // is this step needed??? dont think so? we resolve only after completion
        // mobileAuthCompletion?(request.message, nil)

        mobileAuthCallback = confirmation
        SwiftOneginiPlugin.flutterApi?.n2fOpenAuthOtp(message: request.message) {}
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
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}
        if error.code == ONGGenericError.actionCancelled.rawValue {
            handleMobileAuthCompletion?(.failure(FlutterError(SdkError(.authenticationCancelled))))
            // todo remove
//            mobileAuthCompletion?(false, SdkError(.authenticationCancelled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            handleMobileAuthCompletion?(.failure(FlutterError(mappedError)))
//            mobileAuthCompletion?(false, mappedError)
        }

        handleMobileAuthCompletion = nil
    }

    func userClient(_ userClient: ONGUserClient, didHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, info customAuthenticatorInfo: ONGCustomInfo?) {

        // send event
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        // complete handleOtpRequest
        handleMobileAuthCompletion?(.success)
        handleMobileAuthCompletion = nil

        // todo delete complete after finishing otp
//        mobileAuthCompletion?(request.message, nil)
    }
}
