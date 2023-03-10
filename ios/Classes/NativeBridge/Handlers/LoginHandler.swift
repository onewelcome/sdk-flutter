import OneginiSDKiOS
import Flutter

class LoginHandler: NSObject {
    var pinChallenge: ONGPinChallenge?
    var loginCompletion: ((Result<OWRegistrationResponse, FlutterError>) -> Void)?
    
    func handlePin(pin: String) {
        //FIXME: add a completion handler and errors for in progress
        if let pinChallenge = pinChallenge {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        }
    }
    
    func cancelPinAuthentication() {
        //FIXME: add a completion handler and errors for in progress
        if let pinChallenge = pinChallenge {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
    
    func handleDidReceiveChallenge(_ challenge: ONGPinChallenge) {
        pinChallenge = challenge
        if let pinError = ErrorMapper().mapErrorFromPinChallenge(challenge) {
            BridgeConnector.shared?.toPinConnector.sendNotification(event: PinNotification.nextAuthenticationAttempt, error: pinError)
        } else {
            BridgeConnector.shared?.toPinConnector.sendNotification(event: PinNotification.openAuth, error: nil)
        }
    }
    
    func handleDidAuthenticateUser() {
        pinChallenge = nil
        BridgeConnector.shared?.toPinConnector.sendNotification(event: PinNotification.closeAuth, error: nil)
    }
    
    func handleDidFailToAuthenticateUser() {
        guard pinChallenge != nil else { return }
        BridgeConnector.shared?.toPinConnector.sendNotification(event: PinNotification.closeAuth, error: nil)
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
        loginCompletion?(.success(
            OWRegistrationResponse(userProfile: OWUserProfile(userProfile),
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
