import OneginiSDKiOS
import Flutter

class ChangePinHandler {
    private let loginHandler: LoginHandler
    private let registrationHandler: RegistrationHandler
    init(loginHandler: LoginHandler, registrationHandler: RegistrationHandler) {
        self.loginHandler = loginHandler
        self.registrationHandler = registrationHandler
    }
    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        let delegate = ChangePinDelegateImpl(loginHandler: loginHandler, registrationHandler: registrationHandler, completion: completion)
        SharedUserClient.instance.changePin(delegate: delegate)
    }
}

class ChangePinDelegateImpl: ChangePinDelegate {
    private let completion: ((Result<Void, FlutterError>) -> Void)
    private let loginHandler: LoginHandler
    private let registrationHandler: RegistrationHandler

    init(loginHandler: LoginHandler, registrationHandler: RegistrationHandler, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        self.completion = completion
        self.loginHandler = loginHandler
        self.registrationHandler = registrationHandler
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        loginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didReceiveCreatePinChallenge challenge: CreatePinChallenge) {
        loginHandler.handleDidAuthenticateUser()
        registrationHandler.handleDidReceivePinRegistrationChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didStartPinChangeForUser profile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didChangePinForUser profile: UserProfile) {
        registrationHandler.handleDidRegisterUser()
        completion(.success)
    }

    func userClient(_ userClient: UserClient, didFailToChangePinForUser profile: UserProfile, error: Error) {
        loginHandler.handleDidFailToAuthenticateUser()
        registrationHandler.handleDidFailToRegister()

        let mappedError = ErrorMapper().mapError(error)
        completion(.failure(FlutterError(mappedError)))
    }
}
