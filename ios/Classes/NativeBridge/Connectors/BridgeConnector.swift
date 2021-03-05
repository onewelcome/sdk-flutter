protocol BridgeConnectorProtocol: AnyObject {
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

class BridgeConnector: BridgeConnectorProtocol {
    
    let toRegistrationConnector: BridgeToRegistrationConnectorProtocol = RegistrationConnector()
    let toPinHandlerConnector: BridgeToPinConnectorProtocol = PinConnector()
    let toLoginHandler: BridgeToLoginHandlerProtocol = LoginHandler()
    let toAppToWebHandler: AppToWebHandlerProtocol = AppToWebHandler()
    let toResourceFetchHandler: FetchResourcesProtocol = ResourcesHandler()
    let toMobileAuthConnector: BridgeToMobileAuthConnectorProtocol = MobileAuthConnector()
    var toLogoutUserInteractor = LogoutInteractor()
    var toDeregisterUserInteractor = DisconnectInteractor()
    var toResourcesHandler: FetchResourcesProtocol = ResourcesHandler()
    
    weak var bridge: ConnectorToFlutterBridgeProtocol?
    public static var shared:BridgeConnector?

    init() {
        self.toRegistrationConnector.bridgeConnector = self
        self.toPinHandlerConnector.bridgeConnector = self
        BridgeConnector.shared = self
    }
  
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) {
        bridge?.sendBridgeEvent(eventName: eventName, data: data)
    }
}
