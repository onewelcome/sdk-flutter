import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {

    func pinAcceptAuthenticationRequest(_ pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        bridgeConnector.toLoginHandler.handlePin(pin: pin)
    }
    
    func pinDenyAuthenticationRequest(_ completion: @escaping (Result<Void, Error>) -> Void) {
        bridgeConnector.toLoginHandler.cancelPinAuthentication()
    }
    
    func pinAcceptRegistrationRequest(_ pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        bridgeConnector.toRegistrationConnector.registrationHandler.handlePin(pin: pin)
    }
    
    func pinDenyRegistrationRequest(_ completion: @escaping (Result<Void, Error>) -> Void) {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelPinRegistration()
    }
    
    
    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toChangePinHandler.changePin(completion: completion)
    }
    
    func validatePinWithPolicy(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        // FIXME: Move this out of this file
        ONGUserClient.sharedInstance().validatePin(withPolicy: pin) { (value, error) in
            guard let error = error else {
                completion(.success(()))
                return
            }
            completion(.failure(SdkError(code: error.code, errorDescription: error.localizedDescription).flutterError()))
        }
    }
}

