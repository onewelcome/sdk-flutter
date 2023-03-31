import Foundation
import OneginiSDKiOS

protocol BridgeToAuthenticatorsHandlerProtocol {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func deregisterAuthenticator(_ userProfile: UserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setPreferredAuthenticator(_ userProfile: UserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
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
        let delegate = AuthenticatorRegistrationDelegateImpl(completion)
        SharedUserClient.instance.register(authenticator: authenticator, delegate: delegate)
    }

    func deregisterAuthenticator(_ userProfile: UserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }

        if authenticator.isRegistered != true {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }
        let delegate = AuthenticatorDeregistrationDelegateImpl(completion)
        SharedUserClient.instance.deregister(authenticator: authenticator, delegate: delegate)
    }

    func setPreferredAuthenticator(_ userProfile: UserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }

        // FIXME: Doesnt the sdk give us an error by itself?
        if !authenticator.isRegistered {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }
        SharedUserClient.instance.setPreferred(authenticator: authenticator)
        completion(.success)
    }
}

class AuthenticatorRegistrationDelegateImpl: AuthenticatorRegistrationDelegate {
    private var registrationCompletion: ((Result<Void, FlutterError>) -> Void)?

    init(_ completion: ((Result<Void, FlutterError>) -> Void)?) {
        registrationCompletion = completion
    }

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

class AuthenticatorDeregistrationDelegateImpl: AuthenticatorDeregistrationDelegate {
    private var deregistrationCompletion: ((Result<Void, FlutterError>) -> Void)

    init(_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        deregistrationCompletion = completion
    }

    func userClient(_ userClient: UserClient, didStartDeregistering authenticator: Authenticator, forUser userProfile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didDeregister authenticator: Authenticator, forUser userProfile: UserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion(.success)
    }

    func userClient(_ userClient: UserClient, didFailToDeregister authenticator: Authenticator, forUser userProfile: UserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            deregistrationCompletion(.failure(FlutterError(.authenticatorDeregistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            deregistrationCompletion(.failure(FlutterError(mappedError)))
        }
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthDeregistrationChallenge challenge: CustomAuthDeregistrationChallenge) {
        // We currently don't support custom authenticators
    }
}
