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
        ONGUserClient.sharedInstance().changePin(self)
    }
 }

extension ChangePinHandler: ONGChangePinDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        loginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        loginHandler.handleDidAuthenticateUser()
        registrationHandler.handleDidReceivePinRegistrationChallenge(challenge)
    }

    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        loginHandler.handleDidFailToAuthenticateUser()
        registrationHandler.handleDidFailToRegister()

        let mappedError = ErrorMapper().mapError(error)
        changePinCompletion?(.failure(FlutterError(mappedError)))
        changePinCompletion = nil
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        registrationHandler.handleDidRegisterUser()
        changePinCompletion?(.success)
        changePinCompletion = nil

    }
}
