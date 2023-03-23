import Foundation
import OneginiSDKiOS

protocol MobileAuthConnectorToHandlerProtocol: AnyObject {
    func handleMobileAuthWithOtp2(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class MobileAuthHandler: NSObject {
    var mobileAuthCallback: ((Bool) -> Void)?
    var handleMobileAuthCompletion: ((Result<Void, FlutterError>) -> Void)?
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
}

//MARK: - ONGMobileAuthRequestDelegate
extension MobileAuthHandler: ONGMobileAuthRequestDelegate {
    func userClient(_: ONGUserClient, didReceiveConfirmationChallenge confirmation: @escaping (Bool) -> Void, for request: ONGMobileAuthRequest) {
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
        } else {
            let mappedError = ErrorMapper().mapError(error)
            handleMobileAuthCompletion?(.failure(FlutterError(mappedError)))
        }

        handleMobileAuthCompletion = nil
    }

    func userClient(_ userClient: ONGUserClient, didHandle request: ONGMobileAuthRequest, authenticator: ONGAuthenticator?, info customAuthenticatorInfo: ONGCustomInfo?) {
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        handleMobileAuthCompletion?(.success)
        handleMobileAuthCompletion = nil
    }
}
