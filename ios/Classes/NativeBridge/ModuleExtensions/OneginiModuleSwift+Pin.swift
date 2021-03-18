import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

extension OneginiModuleSwift {
    
    func cancelPinAuth(_ isPin: Bool?) {
        guard let _isPin = isPin, _isPin else {
            return
        }
        
        bridgeConnector.toPinHandlerConnector.pinHandler.onCancel()
    }
  
    func submitPinAction(_ flow: String, action: String, pin: String) -> Void {
        bridgeConnector.toPinHandlerConnector.handlePinAction(flow, action, pin)
     }
    
    func changePin(callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toPinHandlerConnector.pinHandler.onChangePinCalled() {
            (_, error) -> Void in

            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }
}
