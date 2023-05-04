import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func pinAcceptAuthenticationRequest(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toLoginHandler.handlePin(pin: pin, completion: completion)
    }

    func pinDenyAuthenticationRequest(_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toLoginHandler.cancelPinAuthentication(completion: completion)
    }

    func pinAcceptRegistrationRequest(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.handlePin(pin: pin, completion: completion)
    }

    func pinDenyRegistrationRequest(_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toRegistrationHandler.cancelPinRegistration(completion: completion)
    }

    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toChangePinHandler.changePin(completion: completion)
    }

    func validatePinWithPolicy(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        // FIXME: Move this out of this file
        ONGUserClient.sharedInstance().validatePin(withPolicy: pin) { (_, error) in
            guard let error = error else {
                completion(.success)
                return
            }
            completion(.failure(SdkError(code: error.code, errorDescription: error.localizedDescription).flutterError()))
        }
    }
}
