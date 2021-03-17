protocol BridgeToMobileAuthConnectorProtocol: AnyObject {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol { get }

    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?) -> Void
}

class MobileAuthConnector : BridgeToMobileAuthConnectorProtocol {
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        mobileAuthHandler = MobileAuthHandler()
    }

    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?) {
        switch (event){
            case .startAuthentication:
                sendEvent(data: String.stringify(json: ["key": PinNotification.showError.rawValue, "value": error?.errorDescription]))
                break
            case .finishAuthentication:
                sendEvent(data: MobileAuthNotification.finishAuthentication.rawValue)
                break;
        }
    }

  private func sendEvent(data: Any!) {
    bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.authWithOtpNotification, data: data)
  }
}

enum MobileAuthNotification : String {
    case startAuthentication = "eventOpenAuthOtp",
         finishAuthentication = "eventClosePin"
}
