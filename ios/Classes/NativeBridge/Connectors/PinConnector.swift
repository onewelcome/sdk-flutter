protocol BridgeToPinConnectorProtocol: AnyObject {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var pinHandler: PinConnectorToPinHandler { get }

    func handlePinAction(_ flow: String, _ action: String, _ pin: String) -> Void
    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) -> Void
}

//@todo handle change and auth flows
class PinConnector : BridgeToPinConnectorProtocol {
    var pinHandler: PinConnectorToPinHandler
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        pinHandler = PinHandler()
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
                sendEvent(data: ["flow": flow, "action": PinNotification.showError.rawValue, "errorMsg": "Unsupported pin action. Contact SDK maintainer."])
                break
        }
    }

    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) {
        switch (event){
            case .open:
                sendEvent(data: PinNotification.open.rawValue)
                break
            case .confirm:
                sendEvent(data: PinNotification.confirm.rawValue)
                break;
            case .close:
                sendEvent(data: PinNotification.close.rawValue)
                break;
            case .showError:
                sendEvent(data: String.stringify(json: ["key": PinNotification.showError.rawValue, "value": error?.errorDescription]))
                break
        }
    }

  private func sendEvent(data: Any!) {
      bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.pinNotification, data: data)
  }
}

enum PinNotification : String {
    case open = "eventOpenPin",
         confirm = "eventOpenPinConfirmation",
         close = "eventClosePin",
         showError = "show_error"
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
