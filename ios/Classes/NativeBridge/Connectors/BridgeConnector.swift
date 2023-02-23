protocol BridgeConnectorProtocol: AnyObject {
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

class BridgeConnector: BridgeConnectorProtocol {
    
    let toRegistrationConnector: BridgeToRegistrationConnectorProtocol = RegistrationConnector()
    let toPinHandlerConnector: BridgeToPinConnectorProtocol = PinConnector()
    let toLoginHandler: BridgeToLoginHandlerProtocol = LoginHandler()
    let toAppToWebHandler: AppToWebHandlerProtocol = AppToWebHandler()
    let toResourceFetchHandler: FetchResourcesHandlerProtocol = ResourcesHandler()
    let toMobileAuthConnector: BridgeToMobileAuthConnectorProtocol = MobileAuthConnector()
    var toLogoutUserHandler = LogoutHandler()
    var toDeregisterUserHandler = DeregisterUserHandler()
    let toAuthenticatorsHandler: AuthenticatorsHandler = AuthenticatorsHandler()
    
    weak var bridge: ConnectorToFlutterBridgeProtocol?
    public static var shared:BridgeConnector?

    init() {
        self.toRegistrationConnector.bridgeConnector = self
        self.toPinHandlerConnector.bridgeConnector = self
        BridgeConnector.shared = self
        
        let pinHandler = self.toPinHandlerConnector.pinHandler
        self.toRegistrationConnector.registrationHandler.pinHandler = pinHandler
        self.toLoginHandler.pinHandler = pinHandler
        self.toAuthenticatorsHandler.notificationReceiver = toMobileAuthConnector
    }
  
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) {
        bridge?.sendBridgeEvent(eventName: eventName, data: data)
    }
}
