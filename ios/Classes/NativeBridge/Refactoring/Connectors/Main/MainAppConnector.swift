import Foundation

class MainAppConnector {
    private(set) var factory: MainAppConnectorFactoryInterface
    
    init(factory: MainAppConnectorFactoryInterface? = nil) {
        self.factory = factory ?? DefaultMainConnectorFactory()
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.startAppConnector.startApp(call, result)
    }
    
    func fetchResources(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.resourcesConnector.fetchResources(call, result)
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.disconnectConnector.deregisterUser(call, result)
    }
    
    func logoutUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.disconnectConnector.logoutUser(call, result)
    }
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.identityProviderConnector.getIdentityProviders(call, result)
    }
    
    func getUserProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.userProfilesConnector.fetchUserProfiles(call, result)
    }
    
    func singleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.appToWebSingleSignOnConnector.appToWebSingleSignOn(call, result)
    }
    
    func getAllAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.getAllAuthenticators(call, result)
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.getRegisteredAuthenticators(call, result)
    }
    
    func getNonRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.getNonRegisteredAuthenticators(call, result)
    }
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.setPreferredAuthenticator(call, result)
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.registerAuthenticator(call, result)
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.deregisterAuthenticator(call, result)
    }
    
    func isAuthenticatorRegistered(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.isAuthenticatorRegistered(call, result)
    }
}
