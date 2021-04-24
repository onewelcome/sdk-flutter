import Flutter
import UIKit

public class SwiftOneginiPlugin: NSObject, FlutterPlugin {
    
    var flutterConnector: FlutterConnectorProtocol
    
    var oneginiConnector: OneginiConnectorProtocol

    override init() {
//        flutterConnector = FlutterConnector()
        flutterConnector = OneginiModuleSwift.sharedInstance
        
        oneginiConnector = OneginiConnector(flutterConnector: self.flutterConnector)
        
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onegini", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "onegini_events",
                                                  binaryMessenger: registrar.messenger())
        let instance = SwiftOneginiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Logger.log("call.method: \(call.method)", sender: self, logType: .log)
        let arg = call.arguments as! [String: Any]?
        if arg != nil {
            for key in arg!.keys {
                Logger.log("key: " + key)
                let val = arg?[key]
                Logger.log("value: " + String(describing: val))
            }
        }
        
        switch call.method {
        
        // base
        case Constants.Routes.startApp: startApp(call, result) // oneginiConnector.startApp(call, result)
            
        // register
        case Constants.Routes.registerUser: oneginiConnector.registerUser(call, result)
        case Constants.Routes.cancelRegistration: oneginiConnector.cancelRegistration(call, result)
        
        // user
        case Constants.Routes.userProfiles: fetchUserProfiles(result) // oneginiConnector.userProfiles(call, result)
        case Constants.Routes.authenticateUser: authenticateUser(call, result) // oneginiConnector.authenticateUser(call, result)
        case Constants.Routes.getAppToWebSingleSignOn: getAppToWebSingleSignOn(call, result) // oneginiConnector.getAppToWebSingleSignOn(call, result)
        case Constants.Routes.logout: logout(call, result) // oneginiConnector.logout(call, result)
        case Constants.Routes.deregisterUser: deregisterUser(call, result) // oneginiConnector.deregisterUser(call, result)
            
        // authenticator
        case Constants.Routes.getIdentityProviders: getIdentityProviders(call, result) // oneginiConnector.getIdentityProviders(call, result)
        case Constants.Routes.setPreferredAuthenticator: setPreferredAuthenticator(call, result) // oneginiConnector.setPreferredAuthenticator(call, result)
        case Constants.Routes.getRegisteredAuthenticators: getRegisteredAuthenticators(call, result) // oneginiConnector.getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators: getAllNotRegisteredAuthenticators(call, result) // oneginiConnector.getAllNotRegisteredAuthenticators(call, result)
        case Constants.Routes.registerAuthenticator: registerAuthenticator(call, result) // oneginiConnector.registerAuthenticator(call, result)
        case Constants.Routes.deregisterAuthenticator: deregisterAuthenticator(call, result) //
            oneginiConnector.deregisterAuthenticator(call, result)
        
        // pin
        case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result) // oneginiConnector.acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result) // oneginiConnector.denyPinRegistrationRequest(call, result)
        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result) // oneginiConnector.acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result) // oneginiConnector.denyPinAuthenticationRequest(call, result)
        case Constants.Routes.validatePinWithPolicy: validatePinWithPolicy(call, result) // oneginiConnector.validatePinWithPolicy(call, result)
        case Constants.Routes.changePin: oneginiConnector.changePin(call, result)
            
        // custom
        case Constants.Routes.customTwoStepRegistrationReturnSuccess: customTwoStepRegistrationReturnSuccess(call, result) // oneginiConnector.customTwoStepRegistrationReturnSuccess(call, result)
        case Constants.Routes.customTwoStepRegistrationReturnError: customTwoStepRegistrationReturnError(call, result) // oneginiConnector.customTwoStepRegistrationReturnError(call, result)
        
        // fingerprint
        case Constants.Routes.acceptFingerprintAuthenticationRequest: acceptFingerprintAuthenticationRequest(call, result) // oneginiConnector.acceptFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.denyFingerprintAuthenticationRequest: denyFingerprintAuthenticationRequest(call, result) // oneginiConnector.denyFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.fingerprintFallbackToPin: fingerprintFallbackToPin(call, result) // oneginiConnector.fingerprintFallbackToPin(call, result)
            
        // otp
        case Constants.Routes.handleMobileAuthWithOtp: handleMobileAuthWithOtp(call, result) // oneginiConnector.handleMobileAuthWithOtp(call, result)
        case Constants.Routes.acceptOtpAuthenticationRequest: acceptOtpAuthenticationRequest(call, result) // oneginiConnector.acceptOtpAuthenticationRequest(call, result)
        case Constants.Routes.denyOtpAuthenticationRequest: denyOtpAuthenticationRequest(call, result) // oneginiConnector.denyOtpAuthenticationRequest(call, result)
            
        // resources
        case Constants.Routes.getResourceAnonymous, Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.unauthenticatedRequest: getResource(call, result) //
            oneginiConnector.getResource(call, result)
            
        default: do {
            print("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
