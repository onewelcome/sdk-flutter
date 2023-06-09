import Foundation
import OneginiSDKiOS

protocol BridgeToAuthenticatorsHandlerProtocol {
    func registerBiometricAuthenticator(_ profile: UserProfile, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func deregisterBiometricAuthenticator(_ profile: UserProfile, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setPreferredAuthenticator(_ userProfile: UserProfile, _ authenticatorType: AuthenticatorType, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
}

class AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
    private let loginHandler: LoginHandler

    init(loginHandler: LoginHandler) {
        self.loginHandler = loginHandler
    }

    func registerBiometricAuthenticator(_ profile: UserProfile, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        // We don't have to check if the authenticator is already registered as the sdk will do that for us.
        let authenticators = SharedUserClient.instance.authenticators(.all, for: profile)
        guard let authenticator = authenticators.first(where: { $0.type == .biometric }) else {
            completion(.failure(FlutterError(.biometricAuthenticationNotAvailable)))
            return
        }
        let delegate = AuthenticatorRegistrationDelegateImpl(loginHandler: loginHandler, completion: completion)
        SharedUserClient.instance.register(authenticator: authenticator, delegate: delegate)
    }

    func deregisterBiometricAuthenticator(_ profile: UserProfile, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: profile).first(where: { $0.type == .biometric }) else {
            completion(.failure(FlutterError(.biometricAuthenticationNotAvailable)))
            return
        }
        let delegate = AuthenticatorDeregistrationDelegateImpl(completion: completion)
        SharedUserClient.instance.deregister(authenticator: authenticator, delegate: delegate)
    }

    func setPreferredAuthenticator(_ userProfile: UserProfile, _ authenticatorType: AuthenticatorType, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: userProfile).first(where: { $0.type == authenticatorType && $0.isRegistered}) else {
            completion(.failure(FlutterError(.notFoundAuthenticator)))
            return
        }

        SharedUserClient.instance.setPreferredAuthenticator(authenticator)
        completion(.success)
    }

    func getBiometricAuthenticator(_ userProfile: UserProfile, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: userProfile).first(where: { $0.type == AuthenticatorType.biometric }) else {
            completion(.failure(FlutterError(.biometricAuthenticationNotAvailable)))
            return
        }
        completion(.success(OWAuthenticator(id: authenticator.identifier, name: authenticator.name, isRegistered: authenticator.isRegistered, isPreferred: authenticator.isPreferred, authenticatorType: .biometric)))
    }

    func getPreferredAuthenticator(_ userProfile: UserProfile, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        guard let authenticator = SharedUserClient.instance.authenticators(.all, for: userProfile).first(where: { $0.isPreferred }) else {
            completion(.failure(FlutterError(.notFoundAuthenticator)))
            return
        }
        if authenticator.type == .biometric {
            completion(.success(OWAuthenticator(id: authenticator.identifier, name: authenticator.name, isRegistered: authenticator.isRegistered, isPreferred: authenticator.isPreferred, authenticatorType: .biometric)))
            return
        }
        if authenticator.type == .pin {
            completion(.success(OWAuthenticator(id: authenticator.identifier, name: authenticator.name, isRegistered: authenticator.isRegistered, isPreferred: authenticator.isPreferred, authenticatorType: .pin)))
            return
        }
        // Should never happen because we don't support custom/fido authenticators
        completion(.failure(FlutterError(.genericError)))
    }
}

class AuthenticatorRegistrationDelegateImpl: AuthenticatorRegistrationDelegate {
    private let completion: ((Result<Void, FlutterError>) -> Void)
    private let loginHandler: LoginHandler

    init(loginHandler: LoginHandler, completion: (@escaping (Result<Void, FlutterError>) -> Void)) {
        self.completion = completion
        self.loginHandler = loginHandler
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        Logger.log("[AUTH] userClient didReceive PinChallenge", sender: self)
        loginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishRegistrationChallenge challenge: CustomAuthFinishRegistrationChallenge) {
        // We currently don't support custom authenticators
    }

    func userClient(_ userClient: UserClient, didStartRegistering authenticator: Authenticator, for userProfile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didFailToRegister authenticator: Authenticator, for userProfile: UserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToRegister ONGAuthenticator", sender: self)
        loginHandler.handleDidFailToAuthenticateUser()
        let mappedError = ErrorMapper().mapError(error)
        completion(.failure(FlutterError(mappedError)))
    }

    func userClient(_ userClient: UserClient, didRegister authenticator: Authenticator, for userProfile: UserProfile, info customAuthInfo: CustomInfo?) {
        Logger.log("[AUTH] userClient didRegister ONGAuthenticator", sender: self)
        loginHandler.handleDidAuthenticateUser()
        completion(.success)
    }
}

class AuthenticatorDeregistrationDelegateImpl: AuthenticatorDeregistrationDelegate {
    private let completion: ((Result<Void, FlutterError>) -> Void)

    init(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        self.completion = completion
    }

    func userClient(_ userClient: UserClient, didStartDeregistering authenticator: Authenticator, forUser userProfile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didDeregister authenticator: Authenticator, forUser userProfile: UserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        completion(.success)
    }

    func userClient(_ userClient: UserClient, didFailToDeregister authenticator: Authenticator, forUser userProfile: UserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        let mappedError = ErrorMapper().mapError(error)
        completion(.failure(FlutterError(mappedError)))
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthDeregistrationChallenge challenge: CustomAuthDeregistrationChallenge) {
        // We currently don't support custom authenticators
    }
}
