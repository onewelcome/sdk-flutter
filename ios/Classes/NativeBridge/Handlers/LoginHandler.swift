import OneginiSDKiOS
import Flutter

class LoginHandler {
    var pinChallenge: PinChallenge?

    func handlePin(pin: String, completion: (Result<Void, FlutterError>) -> Void) {
        guard let pinChallenge = pinChallenge else {
            completion(.failure(FlutterError(.authenticationNotInProgress)))
            return
        }
        pinChallenge.sender.respond(with: pin, to: pinChallenge)
        completion(.success)
    }

    func cancelPinAuthentication(completion: (Result<Void, FlutterError>) -> Void) {
        guard let pinChallenge = pinChallenge else {
            completion(.failure(FlutterError(.authenticationNotInProgress)))
            return
        }
        pinChallenge.sender.cancel(pinChallenge)
        completion(.success)
    }

    private func mapErrorFromPinChallenge(_ challenge: PinChallenge) -> Error? {
        if let error = challenge.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue {
            return error
        } else {
            return nil
        }
    }

    func handleDidReceiveChallenge(_ challenge: PinChallenge) {
        pinChallenge = challenge
        guard mapErrorFromPinChallenge(challenge) == nil else {
            let authAttempt = OWAuthenticationAttempt(
                failedAttempts: Int64(challenge.previousFailureCount),
                maxAttempts: Int64(challenge.maxFailureCount),
                remainingAttempts: Int64(challenge.remainingFailureCount))
            SwiftOneginiPlugin.flutterApi?.n2fNextAuthenticationAttempt(authenticationAttempt: authAttempt) {}
            return
        }

        SwiftOneginiPlugin.flutterApi?.n2fOpenPinScreenAuth {}
    }

    func handleDidAuthenticateUser() {
        pinChallenge = nil
        SwiftOneginiPlugin.flutterApi?.n2fClosePinAuth {}
    }

    func handleDidFailToAuthenticateUser() {
        guard pinChallenge != nil else { return }
        SwiftOneginiPlugin.flutterApi?.n2fClosePinAuth {}
        pinChallenge = nil
    }

    func authenticateUser(_ profile: UserProfile, authenticator: Authenticator?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        let delegate = AuthenticationDelegateImpl(completion)
        SharedUserClient.instance.authenticateUserWith(profile: profile, authenticator: authenticator, delegate: delegate)
    }
}

class AuthenticationDelegateImpl: AuthenticationDelegate {
    private var loginCompletion: (Result<OWRegistrationResponse, FlutterError>) -> Void

    init(_ completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        loginCompletion = completion
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        BridgeConnector.shared?.toLoginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didStartAuthenticationForUser profile: UserProfile, authenticator: Authenticator) {
        // unused
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishAuthenticationChallenge challenge: CustomAuthFinishAuthenticationChallenge) {
        // We don't support custom authenticators in FlutterPlugin right now.
    }

    func userClient(_ userClient: UserClient, didAuthenticateUser profile: UserProfile, authenticator: Authenticator, info customAuthInfo: CustomInfo?) {
        BridgeConnector.shared?.toLoginHandler.handleDidAuthenticateUser()
        loginCompletion(.success(OWRegistrationResponse(userProfile: OWUserProfile(profile),
                                                         customInfo: toOWCustomInfo(customAuthInfo))))
    }

    func userClient(_ userClient: UserClient, didFailToAuthenticateUser profile: UserProfile, authenticator: Authenticator, error: Error) {
        BridgeConnector.shared?.toLoginHandler.handleDidFailToAuthenticateUser()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            loginCompletion(.failure(FlutterError(.loginCanceled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            loginCompletion(.failure(FlutterError(mappedError)))
        }
    }
}
