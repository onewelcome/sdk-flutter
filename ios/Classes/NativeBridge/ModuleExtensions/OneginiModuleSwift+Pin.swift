import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {
    
    func cancelPinAuth() {
        bridgeConnector.toPinHandlerConnector.pinHandler.onCancel()
    }
  
    func submitPinAction(_ flow: String, action: String, pin: String, isCustomAuth: Bool = false) -> Void {
        if (!isCustomAuth) {
        bridgeConnector.toPinHandlerConnector.handlePinAction(flow, action, pin)
        } else {
            //bridgeConnector.toAuthenticatorsHandler.ha
        }
     }
    
    func changePin(callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toPinHandlerConnector.pinHandler.onChangePinCalled() {
            (_, error) -> Void in

            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }
}

