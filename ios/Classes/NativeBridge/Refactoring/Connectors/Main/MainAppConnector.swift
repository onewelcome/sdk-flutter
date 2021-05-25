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
        self.factory.userProfilesConnector.fetchUserProfiles(result)
    }
}
