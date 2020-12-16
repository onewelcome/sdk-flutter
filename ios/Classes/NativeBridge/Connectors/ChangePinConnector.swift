protocol BridgeToChangePinConnectorProtocol: AnyObject {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var pinView: ChangePinConnectorToViewProtocol? { get set }
  
    func handlePinAction(_ action: String, _ isCreatePinFlow: Bool, _ pin: String) -> Void
    func sendNotification(event: PinNotification, mode: PINEntryMode?, error: SdkError?) -> Void
}

class ChangePinConnector : BridgeToChangePinConnectorProtocol {
    unowned var bridgeConnector: BridgeConnectorProtocol?
    unowned var pinView: ChangePinConnectorToViewProtocol?
    
    func handlePinAction(_ action: String, _ isCreatePinFlow: Bool, _ pin: String) -> Void {
      if(PinAction.provide.rawValue == action){
          pinView?.onPinProvided(pin: pin)
      } else if (PinAction.cancel.rawValue == action){
          pinView?.onCancel()
      } else {
        
      }
    }
  
    func sendNotification(event: PinNotification, mode: PINEntryMode?, error: SdkError?) {
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
            case .authAttempt:
                sendEvent(data: String.stringify(json: ["key": PinNotification.authAttempt.rawValue]))
                break
            case .showError:
                sendEvent(data: String.stringify(json: ["key": PinNotification.showError.rawValue, "value": error?.errorDescription]))
                break
        }
    }
  
  private func sendEvent(data: Any!) {
      bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.pinNotification, data: data)
  }
}


// Pin notification actions for Flutter Bridge
enum PinNotification : String {
    case open = "event_open_pin",
         confirm = "event_open_pin_confirmation",
         close = "event_close_pin",
         authAttempt = "auth_attempt",
         showError = "show_error_pin"
}

// Pin actions from Flutter Bridge
enum PinAction : String {
    case provide = "provide",
         cancel = "cancel",
         create = "create"
}
