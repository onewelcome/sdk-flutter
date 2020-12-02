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
    case "getResource":
        OneginiModuleSwift.sharedInstance.getResources(callback:result)
    case "logOut":
        OneginiModuleSwift.sharedInstance.logOut(callback:result)
    case "deregisterUser":
        OneginiModuleSwift.sharedInstance.deregisterUser(callback:result)
    case "registration": do {
        OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
    }
        
    default:
        result(FlutterMethodNotImplemented)
    }
  }
}
