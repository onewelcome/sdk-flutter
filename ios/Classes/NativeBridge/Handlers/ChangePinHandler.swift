import OneginiSDKiOS
import Flutter

class ChangePinHandler {
    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        let delegate = ChangePinDelegateImpl(completion: completion)
        SharedUserClient.instance.changePin(delegate: delegate)
    }
 }

class ChangePinDelegateImpl: ChangePinDelegate {
    private var changePinCompletion: ((Result<Void, FlutterError>) -> Void)

    init(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        changePinCompletion = completion
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        BridgeConnector.shared?.toLoginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didReceiveCreatePinChallenge challenge: CreatePinChallenge) {
        BridgeConnector.shared?.toLoginHandler.handleDidAuthenticateUser()
        BridgeConnector.shared?.toRegistrationHandler.handleDidReceivePinRegistrationChallenge(challenge)
    }

    func userClient(_ userClient: UserClient, didStartPinChangeForUser profile: UserProfile) {
        // Unused
    }

    func userClient(_ userClient: UserClient, didChangePinForUser profile: UserProfile) {
        BridgeConnector.shared?.toRegistrationHandler.handleDidRegisterUser()
        changePinCompletion(.success)
    }

    func userClient(_ userClient: UserClient, didFailToChangePinForUser profile: UserProfile, error: Error) {
        BridgeConnector.shared?.toLoginHandler.handleDidFailToAuthenticateUser()
        BridgeConnector.shared?.toRegistrationHandler.handleDidFailToRegister()

        let mappedError = ErrorMapper().mapError(error)
        changePinCompletion(.failure(FlutterError(mappedError)))
    }
}
