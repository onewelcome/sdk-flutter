import Foundation
import OneginiSDKiOS
import Flutter

extension OneginiModuleSwift {
    
    func cancelPinAuth() {
        bridgeConnector.toPinHandlerConnector.pinHandler.onCancel()
    }
  
    func submitPinAction(_ flow: String, action: String, pin: String, isCustomAuth: Bool = false) -> Void {
        bridgeConnector.toPinHandlerConnector.handlePinAction(flow, action, pin)
     }
    
    func changePin(callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toPinHandlerConnector.pinHandler.onChangePinCalled() {
            (_, error) -> Void in

            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }
    
    func validatePinWithPolicy(_ pin: String, completion: @escaping (Result<Void, FlutterError>) -> Void) {
        bridgeConnector.toPinHandlerConnector.pinHandler.validatePinWithPolicy(pin: pin, completion: { result in
            completion(result)
        })
    }
}

