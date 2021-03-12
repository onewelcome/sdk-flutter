import UIKit
import Flutter
import onegini
import OneginiSDKiOS
import OneginiCrypto

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
            case "getApplicationDetails": do {
            }
                break
          case "getClientResource": do {
            
          }
//                OneginiModuleSwift.sharedInstance.fetchDevicesList(callback: result)
                break
            case "getImplicitUserDetails": do {
                guard let _profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
                    result(FlutterError.init(code: "400", message: "User profile is null", details: nil))
                    return
                }
                
                var parameters = [String: Any]()
                parameters["path"] = "user-id-decorated"
                parameters["encoding"] = "application/x-www-form-urlencoded";
                parameters["method"] = "GET"
                
                OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(_profile.profileId) { (value, error) in
                    if (error == nil) {
                        OneginiModuleSwift.sharedInstance.resourceRequest(value, parameters: parameters) { (_data, error) in
                            if let _errorResource = error {
                                result(_errorResource)
                                return
                            } else {
                                let userIdDecorated = (_data as! [String: String])["decorated_user_id"]
                                result(userIdDecorated)
                            }
                        }
                    } else {
                        result(error)
                    }
                }
            }
                break
            default:
                result(FlutterMethodNotImplemented)
            }
      })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
