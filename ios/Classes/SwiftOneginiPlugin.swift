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
        }
    }
    
    switch call.method {
    
    // base
    case Constants.Routes.startApp: startApp(call, result)
    
    // register
    case Constants.Routes.registerUser: registration(call, result)
    case Constants.Routes.getIdentityProviders: registration(call, result)
    case Constants.Routes.cancelRegistration: registration(call, result)
    case Constants.Routes.acceptPinRegistrationRequest: registration(call, result)
    case Constants.Routes.denyPinRegistrationRequest: registration(call, result)
    case Constants.Routes.deregisterUser: registration(call, result)
        
    // auth
    case Constants.Routes.authenticateUser: logOut(call, result)
    case Constants.Routes.getRegisteredAuthenticators: logOut(call, result)
    case Constants.Routes.getAllNotRegisteredAuthenticators: logOut(call, result)
    case Constants.Routes.registerAuthenticator: logOut(call, result)
    case Constants.Routes.logout: logOut(call, result)
    case Constants.Routes.acceptPinAuthenticationRequest: logOut(call, result)
    case Constants.Routes.denyPinAuthenticationRequest: logOut(call, result)
        
    // fingerprint
    case Constants.Routes.acceptFingerprintAuthenticationRequest: logOut(call, result)
    case Constants.Routes.denyFingerprintAuthenticationRequest: logOut(call, result)
    case Constants.Routes.fingerprintFallbackToPin: logOut(call, result)
        
    // otp
    case Constants.Routes.handleMobileAuthWithOtp: logOut(call, result)
    case Constants.Routes.acceptOtpAuthenticationRequest: logOut(call, result)
    case Constants.Routes.denyOtpAuthenticationRequest: logOut(call, result)
        
    // resources
    case Constants.Routes.getResourceAnonymous: logOut(call, result)
    case Constants.Routes.getResource: logOut(call, result)
    case Constants.Routes.getImplicitResource: logOut(call, result)
        
    // other
    case Constants.Routes.changePin: logOut(call, result)
    case Constants.Routes.getAppToWebSingleSignOn: logOut(call, result)
    
    default: do {
        print("Method wasn't handled: " + call.method)
        result(FlutterMethodNotImplemented)
    }
    }
  }
}
