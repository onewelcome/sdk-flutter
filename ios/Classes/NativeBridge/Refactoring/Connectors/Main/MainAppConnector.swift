import Foundation

class MainAppConnector {
    private(set) var factory: MainAppConnectorFactoryInterface
    private var pinConnector: PinConnectorProtocol
    private var otpConnector: OTPConnectorProtocol
    
    init(factory: MainAppConnectorFactoryInterface? = nil) {
        self.factory = factory ?? DefaultMainConnectorFactory()
        self.pinConnector = self.factory.pinConnector
        self.otpConnector = self.factory.otpConnector
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.startAppConnector.startApp(call, result)
    }
    
    func getAccessToken(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.startAppConnector.getAccessToken(call, result)
    }
    
    func getRedirectUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.startAppConnector.getRedirectUrl(call, result)
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
    
    func getAuthenticatedUserProfile(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.factory.authenticatorConnector.getAuthenticatedUserProfile(call, result)
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.pinConnector.changePin(call, result)
    }
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.pinConnector.validatePinWithPolicy(call, result)
    }
    
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.otpConnector.handleMobileAuthWithOtp(call, result)
    }
    
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.otpConnector.acceptOtpAuthenticationRequest(call, result)
    }
    
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.otpConnector.denyOtpAuthenticationRequest(call, result)
    }
}
