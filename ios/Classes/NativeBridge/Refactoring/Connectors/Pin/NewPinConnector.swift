import Foundation
import OneginiSDKiOS
import Flutter

protocol PinConnectorProtocol {
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> Void
}

class NewPinConnector: PinConnectorProtocol {
    private(set) var pinWrapper: PinWrapperProtocol
    
    init(wrapper: PinWrapperProtocol = PinWrapper.init()) {
        self.pinWrapper = wrapper
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.pinWrapper.changePin(completion: { (success, error) in
            guard let error = error else {
                result(success)
                return
            }
            
            result(FlutterError.from(error: error))
        })
    }
}
