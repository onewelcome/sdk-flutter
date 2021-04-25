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
        
        // authentication
        case Constants.Routes.authenticateUser: oneginiConnector.authenticateUser(call, result)
        // TODO: consider adding cancel authentication
        
        // user
        case Constants.Routes.logout: logout(call, result) // oneginiConnector.logout(call, result)
        case Constants.Routes.deregisterUser: deregisterUser(call, result) // oneginiConnector.deregisterUser(call, result)
        
        // providers
        case Constants.Routes.userProfiles: oneginiConnector.userProfiles(call, result)
        case Constants.Routes.getIdentityProviders: oneginiConnector.identityProviders(call, result)
        
        // authenticators
        case Constants.Routes.setPreferredAuthenticator: oneginiConnector.setPreferredAuthenticator(call, result)
        case Constants.Routes.getRegisteredAuthenticators: oneginiConnector.getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators: oneginiConnector.getAllNotRegisteredAuthenticators(call, result)
        
        // authenticator registration
        case Constants.Routes.registerAuthenticator: oneginiConnector.registerAuthenticator(call, result)
        case Constants.Routes.deregisterAuthenticator: oneginiConnector.deregisterAuthenticator(call, result)
        
        // pin
        case Constants.Routes.changePin: oneginiConnector.changePin(call, result)
        case Constants.Routes.validatePinWithPolicy: oneginiConnector.validatePinWithPolicy(call, result)
        
        // pin requests
        case Constants.Routes.acceptPinRegistrationRequest: oneginiConnector.acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: oneginiConnector.denyPinRegistrationRequest(call, result)
        case Constants.Routes.acceptPinAuthenticationRequest: oneginiConnector.acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: oneginiConnector.denyPinAuthenticationRequest(call, result)
            
        // fingerprint requests
        case Constants.Routes.acceptFingerprintAuthenticationRequest: oneginiConnector.acceptFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.denyFingerprintAuthenticationRequest: oneginiConnector.denyFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.fingerprintFallbackToPin: oneginiConnector.fingerprintFallbackToPin(call, result)
            
        // custom requests
        case Constants.Routes.customTwoStepRegistrationReturnSuccess: customTwoStepRegistrationReturnSuccess(call, result) // oneginiConnector.customTwoStepRegistrationReturnSuccess(call, result)
        case Constants.Routes.customTwoStepRegistrationReturnError: customTwoStepRegistrationReturnError(call, result) // oneginiConnector.customTwoStepRegistrationReturnError(call, result)
        
        // otp requests
        case Constants.Routes.handleMobileAuthWithOtp: handleMobileAuthWithOtp(call, result) // oneginiConnector.handleMobileAuthWithOtp(call, result)
        case Constants.Routes.acceptOtpAuthenticationRequest: acceptOtpAuthenticationRequest(call, result) // oneginiConnector.acceptOtpAuthenticationRequest(call, result)
        case Constants.Routes.denyOtpAuthenticationRequest: denyOtpAuthenticationRequest(call, result) // oneginiConnector.denyOtpAuthenticationRequest(call, result)
            
        // resources
        case Constants.Routes.getResourceAnonymous, Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.unauthenticatedRequest: getResource(call, result) // oneginiConnector.getResource(call, result)
            
        // app to web
        case Constants.Routes.getAppToWebSingleSignOn: getAppToWebSingleSignOn(call, result) // oneginiConnector.getAppToWebSingleSignOn(call, result)
            
        default: do {
            print("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
