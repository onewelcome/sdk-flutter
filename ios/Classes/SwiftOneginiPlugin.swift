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
#if DEBUG
        print("call.method: ", call.method)
        let _arg = call.arguments as! [String: Any]?
        if ((_arg) != nil) {
            for key in _arg!.keys {
                print("key: " + key)
                let val = _arg?[key]
                print("value: " + String(describing: val))
            }
        }
#endif
        
        switch call.method {
        
        // base
        case Constants.Routes.startApp: oneginiConnector.startApp(call, result)
            
        // register
        case Constants.Routes.registerUser: oneginiConnector.registerUser(call, result)
        case Constants.Routes.cancelRegistration: oneginiConnector.cancelRegistration(call, result)
        
        // user
        case Constants.Routes.userProfiles: oneginiConnector.userProfiles(call, result)
        case Constants.Routes.authenticateUser: oneginiConnector.authenticateUser(call, result)
        case Constants.Routes.getAppToWebSingleSignOn: oneginiConnector.getAppToWebSingleSignOn(call, result)
        case Constants.Routes.logout: oneginiConnector.logout(call, result)
        case Constants.Routes.deregisterUser: oneginiConnector.deregisterUser(call, result)
            
        // authenticator
        case Constants.Routes.getIdentityProviders: oneginiConnector.getIdentityProviders(call, result)
        case Constants.Routes.setPreferredAuthenticator: oneginiConnector.setPreferredAuthenticator(call, result)
        case Constants.Routes.getRegisteredAuthenticators: oneginiConnector.getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators: oneginiConnector.getAllNotRegisteredAuthenticators(call, result)
        case Constants.Routes.registerAuthenticator: oneginiConnector.registerAuthenticator(call, result)
        case Constants.Routes.deregisterAuthenticator:
            oneginiConnector.deregisterAuthenticator(call, result)
        
        // pin
        case Constants.Routes.acceptPinRegistrationRequest: oneginiConnector.acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: oneginiConnector.denyPinRegistrationRequest(call, result)
        case Constants.Routes.acceptPinAuthenticationRequest: oneginiConnector.acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: oneginiConnector.denyPinAuthenticationRequest(call, result)
        case Constants.Routes.validatePinWithPolicy:oneginiConnector.validatePinWithPolicy(call, result)
        case Constants.Routes.changePin: oneginiConnector.changePin(call, result)
            
        // custom
        case Constants.Routes.customTwoStepRegistrationReturnSuccess: oneginiConnector.customTwoStepRegistrationReturnSuccess(call, result)
        case Constants.Routes.customTwoStepRegistrationReturnError: oneginiConnector.customTwoStepRegistrationReturnError(call, result)
        
        // fingerprint
        case Constants.Routes.acceptFingerprintAuthenticationRequest: oneginiConnector.acceptFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.denyFingerprintAuthenticationRequest: oneginiConnector.denyFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.fingerprintFallbackToPin: oneginiConnector.fingerprintFallbackToPin(call, result)
            
        // otp
        case Constants.Routes.handleMobileAuthWithOtp: oneginiConnector.handleMobileAuthWithOtp(call, result)
        case Constants.Routes.acceptOtpAuthenticationRequest: oneginiConnector.acceptOtpAuthenticationRequest(call, result)
        case Constants.Routes.denyOtpAuthenticationRequest: oneginiConnector.denyOtpAuthenticationRequest(call, result)
            
        // resources
        case Constants.Routes.getResourceAnonymous, Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.unauthenticatedRequest:
            oneginiConnector.getResource(call, result)
            
        default: do {
            print("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
