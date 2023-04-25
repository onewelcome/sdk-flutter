import Foundation
import OneginiSDKiOS

protocol MobileAuthConnectorToHandlerProtocol: AnyObject {
    func handleMobileAuthWithOtp(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void)
    func enrollMobileAuthentication(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setMobileAuthCallback(_ confirmation: @escaping (Bool) -> Void)
}

class MobileAuthHandler: NSObject {
    private var mobileAuthCallback: ((Bool) -> Void)?
    private var isFlowInProgress: Bool = false
}

// MARK: - MobileAuthConnectorToHandlerProtocol
extension MobileAuthHandler: MobileAuthConnectorToHandlerProtocol {
    func handleMobileAuthWithOtp(otp: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("handleMobileAuthWithOtp", sender: self)

        // Check to prevent breaking iOS SDK; https://onewelcome.atlassian.net/browse/SDKIOS-987
        guard SharedUserClient.instance.authenticatedUserProfile != nil else {
            completion(.failure(FlutterError(.notAuthenticatedUser)))
            return
        }

        // Prevent concurrent OTP mobile authentication flows at same time; https://onewelcome.atlassian.net/browse/SDKIOS-989
        guard !isFlowInProgress else {
            completion(.failure(FlutterError(.alreadyInProgressMobileAuth)))
            return
        }

        isFlowInProgress = true

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

            let mappedError = ErrorMapper().mapError(error)
            completion(.failure(FlutterError(mappedError)))
        }
    }

    func acceptMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("acceptMobileAuthRequest", sender: self)
        guard let callback = mobileAuthCallback else {
            completion(.failure(FlutterError(SdkError(.notInProgressOtpAuthentication))))
            return
        }

        callback(true)
        mobileAuthCallback = nil
        completion(.success)
    }

    func denyMobileAuthRequest(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("denyMobileAuthRequest", sender: self)
        guard let callback = mobileAuthCallback else {
            completion(.failure(FlutterError(SdkError(.notInProgressOtpAuthentication))))
            return
        }

        callback(false)
        mobileAuthCallback = nil
        completion(.success)
    }

    func setMobileAuthCallback(_ confirmation: @escaping (Bool) -> Void) {
        mobileAuthCallback = confirmation
    }

    func finishMobileAuthenticationFlow() {
        isFlowInProgress = false
    }
}

// MARK: - MobileAuthRequestDelegate
class MobileAuthDelegate: MobileAuthRequestDelegate {
    private var handleMobileAuthCompletion: (Result<Void, FlutterError>) -> Void

    init(handleMobileAuthCompletion: @escaping (Result<Void, FlutterError>) -> Void) {
        self.handleMobileAuthCompletion = handleMobileAuthCompletion
    }

    func userClient(_ userClient: UserClient, didReceiveConfirmation confirmation: @escaping (Bool) -> Void, for request: MobileAuthRequest) {
        BridgeConnector.shared?.toMobileAuthHandler.setMobileAuthCallback(confirmation)
        SwiftOneginiPlugin.flutterApi?.n2fOpenAuthOtp(message: request.message) {}
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge, for request: MobileAuthRequest) {
        // todo: will need this for PUSH
    }

    func userClient(_ userClient: UserClient, didReceiveBiometricChallenge challenge: BiometricChallenge, for request: MobileAuthRequest) {
        // todo: will need this for PUSH
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishAuthenticationChallenge challenge: CustomAuthFinishAuthenticationChallenge, for request: MobileAuthRequest) {
        // todo: will need this for PUSH Custom
    }

    func userClient(_ userClient: UserClient, didFailToHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, error: Error) {
        BridgeConnector.shared?.toMobileAuthHandler.finishMobileAuthenticationFlow()
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        let mappedError = ErrorMapper().mapError(error)
        handleMobileAuthCompletion(.failure(FlutterError(mappedError)))
    }

    func userClient(_ userClient: UserClient, didHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, info customAuthenticatorInfo: CustomInfo?) {
        BridgeConnector.shared?.toMobileAuthHandler.finishMobileAuthenticationFlow()
        SwiftOneginiPlugin.flutterApi?.n2fCloseAuthOtp {}

        handleMobileAuthCompletion(.success)
    }
}
