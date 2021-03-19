protocol BridgeToRegistrationConnectorProtocol: AnyObject {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var registrationHandler: RegistrationConnectorToHandlerProtocol { get }

    func handleCustomRegistrationAction(_ action: String, _ identityProviderId: String, _ code: String?) -> Void
    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification, _ data: Dictionary<String, Any?>?) -> Void
    func sendCustomOtpNotification(_ event: OneginiBridgeEvents, _ data: Dictionary<String, Any?>?) -> Void
}

class RegistrationConnector : BridgeToRegistrationConnectorProtocol {
    var registrationHandler: RegistrationConnectorToHandlerProtocol
    weak var bridgeConnector: BridgeConnectorProtocol?

    init() {
        registrationHandler = RegistrationHandler()
    }

    func handleCustomRegistrationAction(_ action: String, _ identityProviderId: String, _ code: String? = nil) -> Void {
        switch action {
            case CustomRegistrationAction.provide.rawValue:
                registrationHandler.processOTPCode(code: code as String?)
                break
            case CustomRegistrationAction.cancel.rawValue:
                registrationHandler.cancelCustomRegistration()
                break
            default:
                sendEvent(data: ["action": PinNotification.showError.rawValue, "errorMsg": "Unsupported custom registration action. Contact SDK maintainer."])
                break
        }
    }

    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?) {
        
        var _data = data
        switch (event){
            case .initRegistration:
                _data?["eventName"] = CustomRegistrationNotification.initRegistration.rawValue
                
                break
            case .finishRegistration:
                _data?["eventName"] = CustomRegistrationNotification.finishRegistration.rawValue
                break;
        }
        
        sendEvent(data: _data)
    }
    
    func sendCustomOtpNotification(_ event: OneginiBridgeEvents,_ data: Dictionary<String, Any?>?) {
        var _data = data
        _data?["eventName"] = OneginiBridgeEvents.otpOpen.rawValue
        
        let value = String.stringify(json: _data ?? "")
        bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.otpOpen, data: value)
    }

    private func sendEvent(data: Any?) {
        let _data = String.stringify(json: data ?? "")
        bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.customRegistrationNotification, data: _data)
    }
}


// Custom registration notification actions
enum CustomRegistrationNotification : String {
    case initRegistration = "initRegistration",
         finishRegistration = "finishRegistration"
}


// Custom registration actions
enum CustomRegistrationAction : String {
    case provide = "provide",
         cancel = "cancel"
}
