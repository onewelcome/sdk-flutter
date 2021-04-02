//MARK: -
protocol BridgeToMobileAuthConnectorProtocol: AuthenticatorsNotificationReceiverProtocol {
    var bridgeConnector: BridgeConnectorProtocol? { get set }
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol { get }
}

//MARK: -
class MobileAuthConnector : BridgeToMobileAuthConnectorProtocol {
    var mobileAuthHandler: MobileAuthConnectorToHandlerProtocol
    unowned var bridgeConnector: BridgeConnectorProtocol?

    init() {
        mobileAuthHandler = MobileAuthHandler()
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
            print("MobileAuthNotification: ", event.rawValue)
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
