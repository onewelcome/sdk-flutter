import Flutter
import UIKit

public class SwiftOneginiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "onegini", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "onegini_events",
                                              binaryMessenger: registrar.messenger())
    let instance = SwiftOneginiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    print("call.method: ", call.method)
    let _arg = call.arguments as! [String: Any]?
    if ((_arg) != nil) {
        for key in _arg!.keys {
            print("key: " + key)
            let val = _arg?[key]
            print("value: " + String(describing: val))
        }
    }
    
    switch call.method {
    
    // base
    case Constants.Routes.startApp: startApp(call, result)
    
    // register
    case Constants.Routes.registerUser: registerUser(call, result)
    
    case Constants.Routes.getIdentityProviders: getIdentityProviders(call, result)
    case Constants.Routes.cancelRegistration: cancelRegistration(call, result)
    
    case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result)
    case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)
    
    case Constants.Routes.customTwoStepRegistrationReturnSuccess: customTwoStepRegistrationReturnSuccess(call, result)
    case Constants.Routes.customTwoStepRegistrationReturnError: customTwoStepRegistrationReturnError(call, result)
        
    case Constants.Routes.deregisterUser: deregisterUser(call, result)
        
    // auth
    case Constants.Routes.registerAuthenticator: registerAuthenticator(call, result)
    case Constants.Routes.authenticateUser: authenticateUser(call, result)
    
    case Constants.Routes.getRegisteredAuthenticators: getRegisteredAuthenticators(call, result)
    case Constants.Routes.getAllNotRegisteredAuthenticators: getAllNotRegisteredAuthenticators(call, result)
    
    case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
    case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)
    
    case Constants.Routes.logout: logout(call, result)
    
    // fingerprint
    case Constants.Routes.acceptFingerprintAuthenticationRequest: acceptFingerprintAuthenticationRequest(call, result)
    case Constants.Routes.denyFingerprintAuthenticationRequest: denyFingerprintAuthenticationRequest(call, result)
    case Constants.Routes.fingerprintFallbackToPin: fingerprintFallbackToPin(call, result)
        
    // otp
    case Constants.Routes.handleMobileAuthWithOtp: handleMobileAuthWithOtp(call, result)
    case Constants.Routes.acceptOtpAuthenticationRequest: acceptOtpAuthenticationRequest(call, result)
    case Constants.Routes.denyOtpAuthenticationRequest: denyOtpAuthenticationRequest(call, result)
        
    // resources
    case Constants.Routes.getResourceAnonymous, Constants.Routes.getResource, Constants.Routes.getImplicitResource:
        getResource(call, result)
        
    // other
    case Constants.Routes.changePin: changePin(call, result)
    case Constants.Routes.getAppToWebSingleSignOn: getAppToWebSingleSignOn(call, result)
    case Constants.Routes.userProfiles: fetchUserProfiles(ca)
    
    default: do {
        print("Method wasn't handled: " + call.method)
        result(FlutterMethodNotImplemented)
    }
    }
  }
}
