import Flutter
import UIKit

public class SwiftOneginiPlugin: NSObject, FlutterPlugin {
    var mainAppConnector: MainAppConnector
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onegini", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "onegini_events",
                                                  binaryMessenger: registrar.messenger())
        let instance = SwiftOneginiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)
    }
    
    public override init() {
        self.mainAppConnector = MainAppConnector()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Logger.log("call.method: \(call.method)", sender: self, logType: .log)
        let _arg = call.arguments as! [String: Any]?
        if ((_arg) != nil) {
            for key in _arg!.keys {
                Logger.log("key: " + key)
                let val = _arg?[key]
                Logger.log("value: " + String(describing: val))
            }
        }

        switch call.method {

        // base
        case Constants.Routes.startApp: self.mainAppConnector.startApp(call, result)

        // register
        case Constants.Routes.registerUser: registerUser(call, result)
        case Constants.Routes.handleRegisteredUserUrl: handleRegisteredProcessUrl(call, result)

        case Constants.Routes.getIdentityProviders:
            self.mainAppConnector.getIdentityProviders(call, result)
        case Constants.Routes.cancelRegistration: cancelRegistration(call, result)
        case Constants.Routes.setPreferredAuthenticator:
            self.mainAppConnector.setPreferredAuthenticator(call, result)

        case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)

        case Constants.Routes.customTwoStepRegistrationReturnSuccess: customTwoStepRegistrationReturnSuccess(call, result)
        case Constants.Routes.customTwoStepRegistrationReturnError: customTwoStepRegistrationReturnError(call, result)
            
        case Constants.Routes.deregisterUser:
            self.mainAppConnector.deregisterUser(call, result)
            
        // auth
        case Constants.Routes.registerAuthenticator:
            registerAuthenticator(call, result)
            //self.mainAppConnector.registerAuthenticator(call, result)
        case Constants.Routes.authenticateUser: authenticateUser(call, result)

        case Constants.Routes.getRegisteredAuthenticators:
            self.mainAppConnector.getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators:
            self.mainAppConnector.getNonRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllAuthenticators:
            self.mainAppConnector.getAllAuthenticators(call, result)
        case Constants.Routes.deregisterAuthenticator:
            self.mainAppConnector.deregisterAuthenticator(call, result)
        case Constants.Routes.isAuthenticatorRegistered:
            self.mainAppConnector.isAuthenticatorRegistered(call, result)
        case Constants.Routes.getAuthenticatedUserProfile:
            self.mainAppConnector.getAuthenticatedUserProfile(call, result)

        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)

        case Constants.Routes.logout:
            self.mainAppConnector.logoutUser(call, result)
            
        case Constants.Routes.validatePinWithPolicy:
            validatePinWithPolicy(call, result)

        // fingerprint
        case Constants.Routes.acceptFingerprintAuthenticationRequest: acceptFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.denyFingerprintAuthenticationRequest: denyFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.fingerprintFallbackToPin: fingerprintFallbackToPin(call, result)
            
        // otp
        case Constants.Routes.handleMobileAuthWithOtp: handleMobileAuthWithOtp(call, result)
        case Constants.Routes.acceptOtpAuthenticationRequest: acceptOtpAuthenticationRequest(call, result)
        case Constants.Routes.denyOtpAuthenticationRequest: denyOtpAuthenticationRequest(call, result)
            
        // resources
        case Constants.Routes.getAnonymousResource,
             Constants.Routes.getResource,
             Constants.Routes.getImplicitResource,
             Constants.Routes.getUnauthenticatedResource,
             Constants.Routes.authenticateDeviceForResource:
            self.mainAppConnector.fetchResources(call, result)
            
        // other
        case Constants.Routes.changePin: changePin(call, result)
        case Constants.Routes.getAppToWebSingleSignOn:
            self.mainAppConnector.singleSignOn(call, result)
        case Constants.Routes.userProfiles:
            self.mainAppConnector.getUserProfiles(call, result)

        default: do {
            Logger.log("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
