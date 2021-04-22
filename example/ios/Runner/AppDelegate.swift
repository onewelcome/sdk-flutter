import UIKit
import Flutter
import onegini
import OneginiSDKiOS
import OneginiCrypto

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let exampleCustomEventIdentifier: String = "exemple_events"
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

        let methodChannel = FlutterMethodChannel(name: "example",
                                                     binaryMessenger: controller.binaryMessenger)

        let eventChannel = FlutterEventChannel(name: exampleCustomEventIdentifier,
                                                  binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)

        OneginiModuleSwift.sharedInstance.eventSinkCustomIdentifier = exampleCustomEventIdentifier
        
        OneginiModuleSwift.sharedInstance.schemeDeepLink = "oneginiexample"

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
                    OneginiModuleSwift.sharedInstance.cancelCustomRegistration()
                    break
                default:
                    result(FlutterMethodNotImplemented)
                }
          })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let isOneginiUrlCallback: Bool = OneginiModuleSwift.sharedInstance.handleDeepLinkCallbackUrl(url)
        debugPrint(isOneginiUrlCallback)
        
        return true
      }
}
