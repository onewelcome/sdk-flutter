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
    case Constants.Routes.startApp:
        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
    case Constants.Routes.getIdentityProviders:
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    case Constants.Routes.logOut:
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    case Constants.Routes.deregisterUser:
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    case Constants.Routes.cancelRegistration:
        OneginiModuleSwift.sharedInstance.cancelRegistration()
    case Constants.Routes.registration:
        OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
    case Constants.Routes.registrationWithIdentityProvider: do {
        guard let _arg = call.arguments as! [String: String]?, let _identifier = _arg["identityProviderId"] else { break; }
        
        OneginiModuleSwift.sharedInstance.registerUser(_identifier, callback: result)
    }
    case Constants.Routes.sendPin: do {
        guard let _arg = call.arguments as! [String: Any]?, let _pin = _arg["pin"] as! String? else { break; }
        OneginiModuleSwift.sharedInstance.submitPinAction(PinAction.provide.rawValue, isCreatePinFlow: true, pin: _pin)
    }
    case Constants.Routes.authenticateWithRegisteredAuthentication: do {
        guard let _arg = call.arguments as! [String: Any]?, let _id = _arg["registeredAuthenticatorsId"] as! String? else { break; }
        OneginiModuleSwift.sharedInstance.authenticateWithRegisteredAuthentication(_id, callback: result)
    }
    case Constants.Routes.pinAuthentication:
        OneginiModuleSwift.sharedInstance.authenticateUser(nil, callback: result)
    case Constants.Routes.singleSignOn: do {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["url"] as! String? else { break; }
        OneginiModuleSwift.sharedInstance.runSingleSignOn(_path, callback: result)
    }
    case Constants.Routes.changePin:
        OneginiModuleSwift.sharedInstance.changePin(callback: result)
    case Constants.Routes.isUserNotRegisteredFingerprint:
        OneginiModuleSwift.sharedInstance.fetchNotRegisteredAuthenticator(callback: result)
    case Constants.Routes.getRegisteredAuthenticators:
        OneginiModuleSwift.sharedInstance.fetchRegisteredAuthenticators(callback: result)
    case Constants.Routes.registerFingerprintAuthenticator:
        OneginiModuleSwift.sharedInstance.registerFingerprintAuthenticator(callback: result)
    case Constants.Routes.cancelPinAuth: do {
        guard let _arg = call.arguments as! [String: Any]?, let _value = _arg["isPin"] as! Bool? else { break; }
        OneginiModuleSwift.sharedInstance.cancelPinAuth(_value)
    }
    
    case Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.getResourceAnonymous: do {
        guard let _arg = call.arguments as! [String: Any]?, let _path = _arg["path"] as! String? else {
            result(SdkError.init(customType: .incrorrectResourcesAccess).flutterError())
            return
        }
        
        OneginiModuleSwift.sharedInstance.fetchResources(_path, type: call.method, parameters: _arg, callback: result)
    }
    
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
