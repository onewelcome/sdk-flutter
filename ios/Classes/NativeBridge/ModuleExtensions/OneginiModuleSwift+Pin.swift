import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    
    func cancelPinAuth() {
        bridgeConnector.toPinHandlerConnector.pinHandler.onCancel()
    }
  
    func submitPinAction(_ flow: String, action: String, pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toPinHandlerConnector.handlePinAction(flow, action, pin)
     }
    
    func changePin(completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toPinHandlerConnector.pinHandler.onChangePinCalled(completion: completion)
    }
    
    func validatePinWithPolicy(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toPinHandlerConnector.pinHandler.validatePinWithPolicy(pin: pin, completion: completion)
    }
}

