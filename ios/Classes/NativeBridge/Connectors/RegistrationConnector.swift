//MARK: - 
protocol BridgeToRegistrationConnectorProtocol: CustomRegistrationNotificationReceiverProtocol, OtpRegistrationNotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var registrationHandler: RegistrationConnectorToHandlerProtocol & BrowserHandlerToRegisterHandlerProtocol { get }
    func handleCustomRegistrationAction(_ action: String, _ identityProviderId: String, _ code: String?) -> Void
}

//MARK: -
class RegistrationConnector : BridgeToRegistrationConnectorProtocol, CustomRegistrationNotificationReceiverProtocol, OtpRegistrationNotificationReceiverProtocol {
    
    var registrationHandler: RegistrationConnectorToHandlerProtocol & BrowserHandlerToRegisterHandlerProtocol
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        let handler = RegistrationHandler()
        registrationHandler = handler
        handler.customNotificationReceiver = self
        handler.otpNotificationReceiver = self
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
                sendEvent(data: ["eventName": PinNotification.showError.rawValue, "eventValue": SdkError(errorDescription: "Unsupported custom registration action. Contact SDK maintainer.").toJSON() as Any?])
                break
        }
    }

    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?) {
        
        var _data = data
        switch (event){
        case .initRegistration, .finishRegistration, .openCustomTwoStepRegistrationScreen, .eventError, .eventHandleRegisteredUrl:
            _data?["eventName"] = event.rawValue
            break
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

//MARK: -
// Custom registration notification actions
enum CustomRegistrationNotification : String {
    case initRegistration = "initRegistration",
         finishRegistration = "finishRegistration",
         openCustomTwoStepRegistrationScreen = "openCustomTwoStepRegistrationScreen",
         eventError = "eventError",
         eventHandleRegisteredUrl = "eventHandleRegisteredUrl"
}


// Custom registration actions
enum CustomRegistrationAction : String {
    case provide = "provide",
         cancel = "cancel"
}
