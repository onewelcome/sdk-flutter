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
    case "startApp":
        OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
    case "getClientResource":
        OneginiModuleSwift.sharedInstance.fetchDevicesList(callback: result)
    case "getApplicationDetails":
        OneginiModuleSwift.sharedInstance.getApplicationDetails(callback: result)
    case "getImplicitUserDetails":
        OneginiModuleSwift.sharedInstance.fetchImplicitResources(callback: result)
    case "getIdentityProviders":
        OneginiModuleSwift.sharedInstance.identityProviders(callback: result)
    case "logOut":
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    case "deregisterUser":
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    case "registration": do {
        OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
    }
    case "registrationWithIdentityProvider": do {
        guard let _arg = call.arguments as! [String: String]?, let _identifier = _arg["identityProviderId"] else { break; }
        
        OneginiModuleSwift.sharedInstance.registerUser(_identifier, callback: result)
    }
    case "sendPin": do {
        guard let _arg = call.arguments as! [String: String]?, let _pin = _arg["pin"] else { break; }
        OneginiModuleSwift.sharedInstance.submitPinAction(PinAction.provide.rawValue, isCreatePinFlow: true, pin: _pin)
    }
        
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
