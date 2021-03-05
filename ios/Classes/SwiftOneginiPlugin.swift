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
    switch call.method {
    case Constants.Routes.startApp:
        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
    case Constants.Routes.getClientResource:
        OneginiModuleSwift.sharedInstance.fetchDevicesList(callback: result)
    case Constants.Routes.getApplicationDetails:
        OneginiModuleSwift.sharedInstance.getApplicationDetails(callback: result)
    case Constants.Routes.getImplicitUserDetails:
        OneginiModuleSwift.sharedInstance.fetchImplicitResources(callback: result)
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
    
    case Constants.Routes.pinAuthentication:
        OneginiModuleSwift.sharedInstance.authenticateUser(nil, callback: result)
        
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
