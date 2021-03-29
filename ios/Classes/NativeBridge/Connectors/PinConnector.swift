//MARK: - BridgeToPinConnectorProtocol
protocol BridgeToPinConnectorProtocol: NotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var pinHandler: PinConnectorToPinHandler { get }

    func handlePinAction(_ flow: String, _ action: String, _ pin: String) -> Void
}

//MARK: - PinConnector
class PinConnector : BridgeToPinConnectorProtocol, NotificationReceiverProtocol {
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
                sendEvent(data: ["eventName": PinNotification.showError.rawValue, "eventValue": "Unsupported pin action. Contact SDK maintainer."])
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
                sendEvent(data: String.stringify(json: ["eventName": PinNotification.showError.rawValue, "eventValue": error?.errorDescription]))
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
         showError = "eventError"
}

enum PinAction : String {
    case provide = "provide",
         cancel = "cancel"
}

enum PinFlow : String {
    case create = "create",
         change = "change",
         authentication = "authentication"
}
