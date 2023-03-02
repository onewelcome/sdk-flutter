//MARK: - BridgeToPinConnectorProtocol
protocol BridgeToPinConnectorProtocol: PinNotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var pinHandler: PinConnectorToPinHandler { get }

    func handlePinAction(_ flow: String, _ action: String, _ pin: String) -> Void
}

//MARK: - PinConnector
class PinConnector : BridgeToPinConnectorProtocol, PinNotificationReceiverProtocol {
    var pinHandler: PinConnectorToPinHandler
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        let handler = PinHandler()
        pinHandler = handler
        handler.notificationReceiver = self
    }

    func handlePinAction(_ flow: String, _ action: String, _ pin: String) {
        
        switch action {
            case PinAction.provide.rawValue:
                pinHandler.onPinProvided(pin: pin)
                break
            case PinAction.cancel.rawValue:
                pinHandler.onCancel()
                break
            default:
            sendEvent(data: ["eventName": PinNotification.showError.rawValue, "eventValue": SdkError(.unsupportedPinAction).details as Any?])
                break
        }
    }

    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) {
        switch (event){
            case .open:
                sendEvent(data: PinNotification.open.rawValue)
                break
            case .close:
                sendEvent(data: PinNotification.close.rawValue)
                break;
            case .openAuth:
                sendEvent(data: PinNotification.openAuth.rawValue)
                break;
            case .closeAuth:
                sendEvent(data: PinNotification.closeAuth.rawValue)
                break;
            case .showError:
                sendEvent(data: String.stringify(json: ["eventName": PinNotification.showError.rawValue, "eventValue": error?.details as Any?]))
                break
            case .nextAuthenticationAttempt:
                if (error != nil && error?.details["userInfo"] != nil) {
                    sendEvent(data: String.stringify(json: ["eventName": PinNotification.nextAuthenticationAttempt.rawValue, "eventValue": String.stringify(json: error?.details["userInfo"] as Any)]))
                } else {
                    sendEvent(data: String.stringify(json: ["eventName": PinNotification.nextAuthenticationAttempt.rawValue, "eventValue": String.stringify(json: [:]) as Any?]))
                }
                break
        }
    }

  private func sendEvent(data: Any!) {
      bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.pinNotification, data: data)
  }
}

//MARK: -
enum PinNotification : String {
    case open = "eventOpenPin",
         close = "eventClosePin",
         openAuth = "eventOpenPinAuth",
         closeAuth = "eventClosePinAuth",
         showError = "eventError",
         nextAuthenticationAttempt = "eventNextAuthenticationAttempt"
}

enum PinAction : String {
    case provide = "provide",
         cancel = "cancel"
}

enum PinFlow : String {
    case create = "create",
         change = "change",
         authentication = "authentication",
         nextAuthenticationAttempt = "nextAuthenticationAttempt"
}
