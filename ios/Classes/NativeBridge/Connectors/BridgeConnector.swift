class BridgeConnector {
    let toLoginHandler = LoginHandler()
    let toAppToWebHandler: AppToWebHandlerProtocol = AppToWebHandler()
    let toResourceFetchHandler: FetchResourcesHandlerProtocol = ResourcesHandler()
    var toLogoutUserHandler = LogoutHandler()
    var toDeregisterUserHandler = DeregisterUserHandler()
    let toAuthenticatorsHandler: AuthenticatorsHandler
    let toRegistrationHandler = RegistrationHandler()
    let toChangePinHandler: ChangePinHandler
    let toMobileAuthHandler = MobileAuthHandler()
    public static var shared: BridgeConnector?

    init() {
        toChangePinHandler = ChangePinHandler(toLoginHandler, toRegistrationHandler)
        toAuthenticatorsHandler = AuthenticatorsHandler(toLoginHandler)
        BridgeConnector.shared = self
    }
}
