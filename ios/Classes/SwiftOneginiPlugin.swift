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
    switch call.method {
    
    // base
    case Constants.Routes.startApp: startApp(call, result)
    
    // auth
    case Constants.Routes.getIdentityProviders: getIdentityProviders(call, result)
    case Constants.Routes.getRegisteredAuthenticators: getRegisteredAuthenticators(call, result)
    case Constants.Routes.authenticateWithRegisteredAuthentication: authenticateWithRegisteredAuthentication(call, result)
    case Constants.Routes.singleSignOn: singleSignOn(call, result)
    case Constants.Routes.logOut: logOut(call, result)
        
    // register
    case Constants.Routes.registration: registration(call, result)
    case Constants.Routes.registrationWithIdentityProvider: registrationWithIdentityProvider(call, result)
    case Constants.Routes.cancelRegistration: cancelRegistration(call, result)
    case Constants.Routes.deregisterUser: deregisterUser(call, result)
    case Constants.Routes.registerFingerprintAuthenticator: registerFingerprintAuthenticator(call, result)
    case Constants.Routes.isUserNotRegisteredFingerprint: isUserNotRegisteredFingerprint(call, result)
    
    // pin
    case Constants.Routes.sendPin: sendPin(call, result)
    case Constants.Routes.pinAuthentication: pinAuthentication(call, result)
    case Constants.Routes.changePin: changePin(call, result)
    case Constants.Routes.cancelPinAuth: cancelPinAuth(call, result)
        
    // resource
    case Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.getResourceAnonymous: getResource(call, result)
    
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
