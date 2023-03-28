import Foundation
import OneginiSDKiOS

protocol MobileAuthConnectorToHandlerProtocol: AnyObject {
    func handleMobileAuthWithOtp(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setMobileAuthCallback(didReceiveConfirmationChallenge confirmation: @escaping (Bool) -> Void)
}

class MobileAuthHandler: NSObject {
    var mobileAuthCallback: ((Bool) -> Void)?
    var flowStarted: Bool = false
}

//MARK: - MobileAuthConnectorToHandlerProtocol
extension MobileAuthHandler : MobileAuthConnectorToHandlerProtocol {
    func handleMobileAuthWithOtp(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("handleMobileAuthWithOtp", sender: self)

        // Check to prevent breaking iOS SDK; https://onewelcome.atlassian.net/browse/SDKIOS-987
        guard let _ = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }

        // Prevent concurrent OTP mobile authentication flows at same time; https://onewelcome.atlassian.net/browse/SDKIOS-989
        if (flowStarted) {
            completion(.failure(FlutterError(.mobileAuthInProgress)))
            return
        }

        flowStarted = true

        let delegate = MobileAuthDelegate(handleMobileAuthCompletion: completion)
        SharedUserClient.instance.handleOTPMobileAuthRequest(otp: otp, delegate: delegate)
    }

    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("enrollMobileAuthentication", sender: self)
        SharedUserClient.instance.enrollMobileAuth { error in
            guard let error = error else {
                completion(.success)
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

    func setMobileAuthCallback(didReceiveConfirmationChallenge confirmation: @escaping (Bool) -> Void) {
        mobileAuthCallback = confirmation
    }

    func finishMobileAuthenticationFlow() {
        flowStarted = false
    }
}

//MARK: - MobileAuthRequestDelegate
class MobileAuthDelegate: MobileAuthRequestDelegate {
    private var handleMobileAuthCompletion: (Result<Void, FlutterError>) -> Void

    init(handleMobileAuthCompletion: @escaping (Result<Void, FlutterError>) -> Void) {
        self.handleMobileAuthCompletion = handleMobileAuthCompletion
    }

    func userClient(_ userClient: UserClient, didReceiveConfirmation confirmation: @escaping (Bool) -> Void, for request: MobileAuthRequest) {
        BridgeConnector.shared?.toMobileAuthHandler.setMobileAuthCallback(didReceiveConfirmationChallenge: confirmation)
        SwiftOneginiPlugin.flutterApi?.n2fOpenAuthOtp(message: request.message) {}
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge, for request: MobileAuthRequest) {
        //@todo will need this for PUSH
    }

    func userClient(_ userClient: UserClient, didReceiveBiometricChallenge challenge: BiometricChallenge, for request: MobileAuthRequest) {
        //@todo will need this for PUSH
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishAuthenticationChallenge challenge: CustomAuthFinishAuthenticationChallenge, for request: MobileAuthRequest) {
        //@todo will need this for PUSH Custom
    }

    func userClient(_ userClient: UserClient, didFailToHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, error: Error) {
        BridgeConnector.shared?.toMobileAuthHandler.finishMobileAuthenticationFlow()
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        if error.code == ONGGenericError.actionCancelled.rawValue {
            self.handleMobileAuthCompletion(.failure(FlutterError(SdkError(.authenticationCancelled))))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            self.handleMobileAuthCompletion(.failure(FlutterError(mappedError)))
        }
    }

    func userClient(_ userClient: UserClient, didHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, info customAuthenticatorInfo: CustomInfo?) {
        BridgeConnector.shared?.toMobileAuthHandler.finishMobileAuthenticationFlow()
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        self.handleMobileAuthCompletion(.success)
    }
}
