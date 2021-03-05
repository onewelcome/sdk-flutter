import UIKit
import Flutter
import onegini

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    let methodChannel = FlutterMethodChannel(name: "example",
                                                 binaryMessenger: controller.binaryMessenger)

    let eventChannel = FlutterEventChannel(name: "exemple_events",
                                              binaryMessenger: controller.binaryMessenger)
    eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)

    OneginiModuleSwift.sharedInstance.configureCustomRegIdentifier("2-way-otp-api")
    OneginiModuleSwift.sharedInstance.eventSinkParameter = "exemple_events"

    methodChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
            case "otpOk":
                var value: String = ""
                if let _arguments = call.arguments as? [String: String?], let pass = _arguments["password"]  {
                    value = pass ?? ""
                }
                OneginiModuleSwift.sharedInstance.otpResourceCodeConfirmation(code: value, callback: result)
                break
            case "otpCancel":
                OneginiModuleSwift.sharedInstance.cancelRegistration()
                break
            case "getApplicationDetails":
                OneginiModuleSwift.sharedInstance.getApplicationDetails(callback: result)
                break
            case "getClientResource":
                OneginiModuleSwift.sharedInstance.fetchDevicesList(callback: result)
                break
            case "getImplicitUserDetails":
                OneginiModuleSwift.sharedInstance.fetchImplicitResources(callback: result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
      })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
