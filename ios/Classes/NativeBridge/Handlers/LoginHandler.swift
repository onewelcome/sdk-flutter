import OneginiSDKiOS
import Flutter

class LoginHandler: NSObject {
    var pinChallenge: ONGPinChallenge?
    var loginCompletion: ((Result<OWRegistrationResponse, FlutterError>) -> Void)?
    
    func handlePin(pin: String, completion: (Result<Void, FlutterError>) -> Void) {
        guard let pinChallenge = pinChallenge else {
            completion(.failure(FlutterError(.authenticationNotInProgress)))
            return
        }
        pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
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
    
    func handleDidReceiveChallenge(_ challenge: ONGPinChallenge) {
        pinChallenge = challenge
        guard let error = challenge.error , error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue else {
            SwiftOneginiPlugin.flutterApi?.n2fOpenPinScreenAuth {}
            return
        }
        let authAttempt = OWAuthenticationAttempt(
            failedAttempts: Int32(challenge.previousFailureCount),
            maxAttempts: Int32(challenge.maxFailureCount),
            remainingAttempts: Int32(challenge.remainingFailureCount))
        SwiftOneginiPlugin.flutterApi?.n2fNextAuthenticationAttempt(authenticationAttempt: authAttempt) {}
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
}

extension LoginHandler {
    func authenticateUser(_ profile: ONGUserProfile, authenticator: ONGAuthenticator?, completion: @escaping (Result<OWRegistrationResponse, FlutterError>) -> Void) {
        loginCompletion = completion
        ONGUserClient.sharedInstance().authenticateUser(profile, authenticator: authenticator, delegate: self)
    }
}

extension LoginHandler: ONGAuthenticationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        handleDidReceiveChallenge(challenge)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge) {
        // We don't support custom authenticators in FlutterPlugin right now.
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, info customAuthInfo: ONGCustomInfo?) {
        handleDidAuthenticateUser()
        loginCompletion?(.success(OWRegistrationResponse(userProfile: OWUserProfile(userProfile),
                                                         customInfo: toOWCustomInfo(customAuthInfo))))
    }

    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, error: Error) {
        handleDidFailToAuthenticateUser()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            loginCompletion?(.failure(FlutterError(.loginCanceled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            loginCompletion?(.failure(FlutterError(mappedError)))
        }
    }
}
