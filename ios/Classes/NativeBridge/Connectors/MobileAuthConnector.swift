//MARK: -
protocol BridgeToMobileAuthConnectorProtocol: AuthenticatorsNotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol { get }
}

//MARK: -
class MobileAuthConnector : BridgeToMobileAuthConnectorProtocol, MobileAuthNotificationReceiverProtocol {
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        let handler = MobileAuthHandler()
        mobileAuthHandler = handler
        handler.notificationReceiver = self
    }

    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?) {
        switch (event){
            case .startAuthentication:
                sendEvent(data:MobileAuthNotification.startAuthentication.rawValue)
                break
            case .finishAuthentication:
                sendEvent(data: MobileAuthNotification.finishAuthentication.rawValue)
                break;
        default:
            Logger.log("MobileAuthNotification: \(event.rawValue)", sender: self)
        }
    }

  private func sendEvent(data: Any!) {
    bridgeConnector?.sendBridgeEvent(eventName: OneginiBridgeEvents.authWithOtpNotification, data: data)
  }
}

//MARK: -
enum MobileAuthNotification : String {
    case eventOpenAuthOtp = "eventOpenAuthOtp",
         startAuthentication = "eventOpenPin",
         finishAuthentication = "eventClosePin"
}
