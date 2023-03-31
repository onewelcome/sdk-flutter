import Foundation
import OneginiSDKiOS

protocol BridgeToAuthenticatorsHandlerProtocol: AnyObject {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class AuthenticatorsHandler: NSObject {
    var pinChallenge: PinChallenge?
    var customAuthChallenge: ONGCustomAuthFinishRegistrationChallenge?
    var registrationCompletion: ((Result<Void, FlutterError>) -> Void)?
    var deregistrationCompletion: ((Result<Void, FlutterError>) -> Void)?

    func handlePin(pin: String?) {
        guard let customAuthChallenge = self.customAuthChallenge else {
            guard let pinChallenge = self.pinChallenge else { return }

            if let pin = pin {
                pinChallenge.sender.respond(with: pin, to: pinChallenge)

            } else {
                pinChallenge.sender.cancel(pinChallenge)
            }

            return
        }

        if let pin = pin {
            customAuthChallenge.sender.respond(withData: pin, challenge: customAuthChallenge)

        } else {
            customAuthChallenge.sender.cancel(customAuthChallenge, underlyingError: nil)
        }
    }
}

extension AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let profile = SharedUserClient.instance.authenticatedUserProfile else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }

        // We don't have to check if the authenticator is already registered as the sdk will do that for us.
        let authenticators = SharedUserClient.instance.authenticators(.all, for: profile)
        guard let authenticator = authenticators.first(where: { $0.identifier == authenticatorId }) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }
        registrationCompletion = completion
        SharedUserClient.instance.register(authenticator: authenticator, delegate: self)
    }

    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }

        if authenticator.isRegistered != true {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }

        deregistrationCompletion = completion
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }

    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }

        // FIXME: Doesnt the sdk give us an error by itself?
        if !authenticator.isRegistered {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }

        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
        completion(.success)
    }
}

extension AuthenticatorsHandler: AuthenticatorRegistrationDelegate {
    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        Logger.log("[AUTH] userClient didReceive PinChallenge", sender: self)
        BridgeConnector.shared?.toLoginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishRegistrationChallenge challenge: CustomAuthFinishRegistrationChallenge) {
        // We currently don't support custom authenticators
    }

    func userClient(_ userClient: UserClient, didStartRegistering authenticator: Authenticator, for userProfile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didFailToRegister authenticator: Authenticator, for userProfile: UserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToRegister ONGAuthenticator", sender: self)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registrationCompletion?(.failure(FlutterError(.authenticatorRegistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registrationCompletion?(.failure(FlutterError(mappedError)))
        }
    }

    func userClient(_ userClient: UserClient, didRegister authenticator: Authenticator, for userProfile: UserProfile, info customAuthInfo: CustomInfo?) {
        Logger.log("[AUTH] userClient didRegister ONGAuthenticator", sender: self)
        BridgeConnector.shared?.toLoginHandler.handleDidAuthenticateUser()
        registrationCompletion?(.success)
    }
}

extension AuthenticatorsHandler: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion?(.success)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        // We currently don't support custom authenticators
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            deregistrationCompletion?(.failure(FlutterError(.authenticatorDeregistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            deregistrationCompletion?(.failure(FlutterError(mappedError)))
        }
    }
}
