import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol ConnectorToFlutterBridgeProtocol: NSObject {
  func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

enum OneginiBridgeEvents : String {
    case pinNotification = "ONEGINI_PIN_NOTIFICATION"
    case otpOpen = "ONEGINI_OTP_OPEN"
    case errorNotification = "ONEGINI_ERROR_NOTIFICATION"
}

public class OneginiModuleSwift: NSObject, ConnectorToFlutterBridgeProtocol, FlutterStreamHandler {
 
    // Pin test default value
    static let pinTestValue: String = "55668"
    var bridgeConnector: BridgeConnector
    private var eventSink: FlutterEventSink?
    var resourcesHandler: FetchResourcesProtocol
    var authUserProfile: ONGUserProfile?
    public var eventSinkNativePart: FlutterEventSink?
    public var eventSinkParameter: String?
    
    var customIdentifier: String? {
        didSet {
            print(customIdentifier ?? "")
        }
    }
    

    static public let sharedInstance = OneginiModuleSwift()
    
    override init() {
        self.bridgeConnector = BridgeConnector()
        self.resourcesHandler = ResourcesHandler()
        super.init()
        self.bridgeConnector.bridge = self
    }
    
    public func configureCustomRegIdentifier(_ identifier: String) {
        self.customIdentifier = identifier
    }
    
    func supportedEvents() -> [String]! {
        return [OneginiBridgeEvents.pinNotification.rawValue]
    }
    

    func getRedirectUri(_ callback: (@escaping FlutterResult)) -> Void {
        let redirectUri = ONGClient.sharedInstance().configModel.redirectURL;
      
        callback([["success" : true, "redirectUri" : redirectUri!]])
    }
    
    func startOneginiModule(callback: @escaping FlutterResult) {
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start {
          result1, error in
            callback(result1)
        }
    }
    
    public func otpResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
        bridgeConnector.toRegistrationHandler.handleOTPRegistration(code: code)
    }
    
    func getApplicationDetails(callback: @escaping FlutterResult) {
        self.resourcesHandler.fetchAppDetails { (data, error) in
            print(data ?? "")
            error != nil ? callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON())) : callback(data)
        }
    }
    
    func fetchDevicesList(callback: @escaping FlutterResult) {
        self.resourcesHandler.fetchDeviceList { (data, error) in
            error != nil ? callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON())) : callback(data)
        }
    }

    func fetchImplicitResources(callback: @escaping FlutterResult) {
        guard let _profile = self.authUserProfile else { return }
        self.resourcesHandler.fetchImplicitResources(profile: _profile) { (data, error) in
            debugPrint(data ?? "", error ?? "")
            error != nil ? callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON())) : callback(data)
        }
    }
    
    func identityProviders(callback: @escaping FlutterResult) {
        let _providers = self.bridgeConnector.toRegistrationHandler.identityProviders()
        let jsonData = _providers.compactMap { (identityProvider) -> [String: Any]? in
            var data = [String: Any]()
            data["id"] = identityProvider.identifier
            data["name"] = identityProvider.name
            return data
        }
        
        let data = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        let convertedString = data != nil ? String(data: data!, encoding: String.Encoding.utf8) : "[]"
        callback(convertedString)
    }
    
    func logOut(callback: @escaping FlutterResult) {
        bridgeConnector.toRegistrationHandler.logout { (error) in
            error != nil ? callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON())) : callback(true)
        }
    }
    
    func deregisterUser(callback: @escaping FlutterResult) {
        bridgeConnector.toRegistrationHandler.deregister { (error) in
            error != nil ? callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON())) : callback(true)
        }
    }
    
    func registerUser(_ identityProviderId: String? = nil, callback: @escaping FlutterResult) -> Void {
         bridgeConnector.toRegistrationHandler.signUp(identityProviderId) { [weak self]
           (_, userProfile, error) -> Void in
          
             if let userProfile = userProfile {
                self?.authUserProfile = userProfile
                 callback(userProfile.profileId)
             } else {
                 
                 callback(FlutterError(code: "401", message: error?.errorDescription ?? "Unexpected Error.", details: error?.toJSON()))
             }
          
         }
     }
    
     func handleRegistrationCallback(_ url: (NSString)) -> Void {
         bridgeConnector.toRegistrationHandler.handleRedirectURL(url: URL(string: url as String)!)
     }
    
     public func cancelRegistration() -> Void {
         bridgeConnector.toRegistrationHandler.cancelRegistration()
     }
  
     func submitPinAction(_ action: String, isCreatePinFlow: Bool, pin: String) -> Void {
         bridgeConnector.toChangePinConnector.handlePinAction(action, isCreatePinFlow, pin)
     }
    
     func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void {
        debugPrint(sendBridgeEvent)
        if eventName == OneginiBridgeEvents.otpOpen {
            eventSinkNativePart?(data)
            return;
        }
        
        guard let _eventSink = eventSink else {
          return
        }
        
        _eventSink(data)
     }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let _value = eventSinkParameter, let _arg = arguments as! String?, _value == _arg {
            self.eventSinkNativePart = events
        } else if let _arg = arguments as! String?, _arg == "onegini_events" {
            eventSink = events
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        eventSinkNativePart = nil
        return nil
    }

    
}

