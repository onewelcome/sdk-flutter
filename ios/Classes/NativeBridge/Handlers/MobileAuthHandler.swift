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
    // MARK: - Mobile auth with PUSH
    func enrollMobileAuthenticationWithPush(token: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("enrollMobileAuthenticationWithPush", sender: self)
        SharedUserClient.instance.enrollPushMobileAuth(with: Data(token.utf8)) { error in
            guard let error = error else {
                completion(.success)
                return
            }

            let mappedError = ErrorMapper().mapError(error)
            completion(.failure(FlutterError(mappedError)))
        }
    }

    func isUserEnrolledForMobileAuthWithPush(profile: UserProfile, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("isUserEnrolledForMobileAuthWithPush", sender: self)
        if SharedUserClient.instance.isPushMobileAuthEnrolled(for: profile) {
            completion(.success)
        } else {
            completion(.failure(SdkError(.notEnrolledForMobileAuthWithPush).flutterError()))
        }
    }

    func denyMobileAuthWithPushRequest(request: OWMobileAuthWithPushRequest, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("denyMobileAuthWithPushRequest", sender: self)
        guard let pendingTransaction = SharedUserClient.instance.pendingMobileAuthRequest(from: ["og_transaction_id": request.transactionId, "og_profile_id": request.userProfileId]) else {
            completion(.failure(SdkError(.notFoundMobileAuthRequest).flutterError()))
            return
        }
        let delegate = MobileAuthWithPushDelegate(handleMobileAuthCompletion: completion, accept: false)
        SharedUserClient.instance.handlePendingMobileAuthRequest(pendingTransaction, delegate: delegate)
    }

    func acceptMobileAuthWithPushRequest(request: OWMobileAuthWithPushRequest, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        Logger.log("acceptMobileAuthWithPushRequest", sender: self)
        guard let pendingTransaction = SharedUserClient.instance.pendingMobileAuthRequest(from: ["og_transaction_id": request.transactionId, "og_profile_id": request.userProfileId]) else {
            completion(.failure(SdkError(.notFoundMobileAuthRequest).flutterError()))
            return
        }
        let delegate = MobileAuthWithPushDelegate(handleMobileAuthCompletion: completion, accept: true)
        SharedUserClient.instance.handlePendingMobileAuthRequest(pendingTransaction, delegate: delegate)
    }

    func getPendingMobileAuthWithPushRequests(completion: @escaping (Result<[OWMobileAuthWithPushRequest], FlutterError>) -> Void) {
        Logger.log("getPendingMobileAuthWithPushRequests", sender: self)
        SharedUserClient.instance.pendingPushMobileAuthRequests { requests, error in
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(.failure(appError.flutterError()))
            } else if let requests = requests {
                completion(.success(requests.map { OWMobileAuthWithPushRequest($0) }))
            } else {
                completion(.success([]))
            }
        }
    }

    // MARK: - Mobile auth with OTP
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

        let delegate = MobileAuthOTPDelegate(handleMobileAuthCompletion: completion)
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

class MobileAuthOTPDelegate: MobileAuthRequestDelegate {
    private var handleMobileAuthCompletion: (Result<Void, FlutterError>) -> Void

    init(handleMobileAuthCompletion: @escaping (Result<Void, FlutterError>) -> Void) {
        self.handleMobileAuthCompletion = handleMobileAuthCompletion
    }

    func userClient(_ userClient: UserClient, didReceiveConfirmation confirmation: @escaping (Bool) -> Void, for request: MobileAuthRequest) {
        BridgeConnector.shared?.toMobileAuthHandler.setMobileAuthCallback(confirmation)
        SwiftOneginiPlugin.flutterApi?.n2fOpenAuthOtp(message: request.message) {}
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

class MobileAuthWithPushDelegate: MobileAuthRequestDelegate {
    private let handleMobileAuthCompletion: (Result<Void, FlutterError>) -> Void
    private let accept: Bool

    init(handleMobileAuthCompletion: @escaping (Result<Void, FlutterError>) -> Void, accept: Bool) {
        self.handleMobileAuthCompletion = handleMobileAuthCompletion
        self.accept = accept
    }

    func userClient(_ userClient: UserClient, didReceiveConfirmation confirmation: @escaping (Bool) -> Void, for request: MobileAuthRequest) {
        confirmation(accept)
    }

    func userClient(_ userClient: UserClient, didFailToHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, error: Error) {
        if authenticator?.type == AuthenticatorType.pin {
            BridgeConnector.shared?.toLoginHandler.handleDidFailToAuthenticateUser()
        }

        let mappedError = ErrorMapper().mapError(error)
        handleMobileAuthCompletion(.failure(FlutterError(mappedError)))
    }

    func userClient(_ userClient: UserClient, didHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, info customAuthenticatorInfo: CustomInfo?) {
        if authenticator?.type == AuthenticatorType.pin {
            BridgeConnector.shared?.toLoginHandler.handleDidAuthenticateUser()
        }

        handleMobileAuthCompletion(.success)
    }

    func userClient(_ userClient: OneginiSDKiOS.UserClient, didReceivePinChallenge challenge: OneginiSDKiOS.PinChallenge, for request: OneginiSDKiOS.MobileAuthRequest) {
        BridgeConnector.shared?.toLoginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: OneginiSDKiOS.UserClient, didReceiveBiometricChallenge challenge: OneginiSDKiOS.BiometricChallenge, for request: OneginiSDKiOS.MobileAuthRequest) {
        // We actually don't have to handle this ourselves, the sdk will handle this with a native biometric popup.
    }
}
