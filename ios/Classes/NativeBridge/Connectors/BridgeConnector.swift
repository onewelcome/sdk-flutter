protocol BridgeConnectorProtocol: AnyObject {
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

class BridgeConnector: BridgeConnectorProtocol {
    

    let toPinConnector = PinConnector()
    let toLoginHandler: LoginHandler = LoginHandler()
    let toAppToWebHandler: AppToWebHandlerProtocol = AppToWebHandler()
    let toResourceFetchHandler: FetchResourcesHandlerProtocol = ResourcesHandler()
    let toMobileAuthConnector: BridgeToMobileAuthConnectorProtocol = MobileAuthConnector()
    var toLogoutUserHandler = LogoutHandler()
    var toDeregisterUserHandler = DeregisterUserHandler()
    let toAuthenticatorsHandler: AuthenticatorsHandler = AuthenticatorsHandler()
    let toRegistrationConnector: BridgeToRegistrationConnectorProtocol
    let toChangePinHandler: ChangePinHandler
    weak var bridge: ConnectorToFlutterBridgeProtocol?
    public static var shared:BridgeConnector?

    init() {
        self.toRegistrationConnector = RegistrationConnector(handler: RegistrationHandler())
        self.toAuthenticatorsHandler.notificationReceiver = toMobileAuthConnector
        self.toChangePinHandler = ChangePinHandler(loginHandler: toLoginHandler, registrationHandler: toRegistrationConnector.registrationHandler)
        
        self.toRegistrationConnector.bridgeConnector = self
        self.toPinConnector.bridgeConnector = self
        BridgeConnector.shared = self
    }
  
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) {
        bridge?.sendBridgeEvent(eventName: eventName, data: data)
    }
}
