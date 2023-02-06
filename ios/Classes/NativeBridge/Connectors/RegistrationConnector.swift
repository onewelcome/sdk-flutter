//MARK: - 
protocol BridgeToRegistrationConnectorProtocol: CustomRegistrationNotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var registrationHandler: RegistrationConnectorToHandlerProtocol & BrowserHandlerToRegisterHandlerProtocol { get }
}

//MARK: -
class RegistrationConnector : BridgeToRegistrationConnectorProtocol, CustomRegistrationNotificationReceiverProtocol {
    var registrationHandler: RegistrationConnectorToHandlerProtocol & BrowserHandlerToRegisterHandlerProtocol
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        let handler = RegistrationHandler()
        registrationHandler = handler
        handler.customNotificationReceiver = self
    }

    func sendCustomRegistrationNotification(_ event: CustomRegistrationNotification,_ data: Dictionary<String, Any?>?) {
        
        var _data = data
        switch (event){
        case .initRegistration, .finishRegistration, .eventError, .eventHandleRegisteredUrl:
            _data?["eventName"] = event.rawValue
            break
        }
        
        sendEvent(data: _data)
    }

    private func sendEvent(data: Any?) {
        let _data = String.stringify(json: data ?? "")
        bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.customRegistrationNotification, data: _data)
    }
}

//MARK: -
// Custom registration notification actions
enum CustomRegistrationNotification : String {
    case initRegistration = "eventInitCustomRegistration",
         finishRegistration = "eventFinishCustomRegistration",
         eventError = "eventError",
         eventHandleRegisteredUrl = "eventHandleRegisteredUrl"
}


// Custom registration actions
enum CustomRegistrationAction : String {
    case provide = "provide",
         cancel = "cancel"
}
