import UIKit
import Flutter
import OneginiSDKiOS

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterBinaryMessenger {
    func send(onChannel channel: String, message: Data?) {

    }

    func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {

    }

    func setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil) -> FlutterBinaryMessengerConnection {
        return 0
    }

    func cleanupConnection(_ connection: FlutterBinaryMessengerConnection) {

    }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let oneginiSdkChannel = FlutterMethodChannel(name: "com.onegini/sdk",
                                                 binaryMessenger: controller.binaryMessenger)

    oneginiSdkChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
            case "startApp":
                OneginiModuleSwift.sharedInstance.startOneginiModule(callback: result)
          case "getResource":
                OneginiModuleSwift.sharedInstance.getResources(callback:result)
            case "registration": do {
                OneginiModuleSwift.sharedInstance.registerUser(nil, callback: result)
          }
            
            default:
                result(FlutterMethodNotImplemented)
            }
      })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
