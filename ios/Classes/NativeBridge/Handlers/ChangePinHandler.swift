import OneginiSDKiOS
import Flutter

class ChangePinHandler: NSObject {
    var changePinCompletion: ((Result<Void, FlutterError>) -> Void)?
    private let loginHandler: LoginHandler
    private let registrationHandler: RegistrationHandler

    init(loginHandler: LoginHandler, registrationHandler: RegistrationHandler) {
        self.loginHandler = loginHandler
        self.registrationHandler = registrationHandler
    }
}

extension ChangePinHandler {
    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        changePinCompletion = completion
        SharedUserClient.instance.changePin(delegate: self)
    }
 }

extension ChangePinHandler: ChangePinDelegate {
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
        changePinCompletion?(.success)
        changePinCompletion = nil
    }

    func userClient(_ userClient: UserClient, didFailToChangePinForUser profile: UserProfile, error: Error) {
        loginHandler.handleDidFailToAuthenticateUser()
        registrationHandler.handleDidFailToRegister()

        let mappedError = ErrorMapper().mapError(error)
        changePinCompletion?(.failure(FlutterError(mappedError)))
        changePinCompletion = nil
    }
}
