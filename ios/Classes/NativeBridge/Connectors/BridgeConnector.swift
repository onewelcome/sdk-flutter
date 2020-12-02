protocol BridgeConnectorProtocol: AnyObject {
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

class BridgeConnector : BridgeConnectorProtocol {
    let toRegistrationHandler: BridgeToRegisterViewProtocol
    var toChangePinConnector: BridgeToChangePinConnectorProtocol
    weak var bridge: ConnectorToFlutterBridgeProtocol?
    
    public static var sharedInstance: BridgeConnector?
    
    init() {
        self.toRegistrationHandler = RegistrationHandler()
        self.toChangePinConnector = ChangePinConnector()
        self.toChangePinConnector.bridgeConnector = self
        BridgeConnector.sharedInstance = self
    }
  
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) {
        bridge?.sendBridgeEvent(eventName: eventName, data: data)
    }
}
