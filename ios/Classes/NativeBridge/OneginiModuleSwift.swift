import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol ConnectorToFlutterBridgeProtocol: NSObject {
  func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

enum OneginiBridgeEvents : String {
    case pinNotification = "ONEGINI_PIN_NOTIFICATION"
    case customRegistrationNotification = "ONEGINI_CUSTOM_REGISTRATION_NOTIFICATION"
    case authWithOtpNotification = "ONEGINI_MOBILE_AUTH_OTP_NOTIFICATION"
    case otpOpen = "OPEN_OTP"
    case errorNotification = "ONEGINI_ERROR_NOTIFICATION"
}

//MARK: -
public class OneginiModuleSwift: NSObject, ConnectorToFlutterBridgeProtocol, FlutterStreamHandler {
 
    var bridgeConnector: BridgeConnector
    private var eventSink: FlutterEventSink?
    public var eventSinkNativePart: FlutterEventSink?
    public var eventSinkCustomIdentifier: String?
    public var customRegIdentifiers = [String]()
    public var schemeDeepLink: String!
    
    static public let sharedInstance = OneginiModuleSwift()
    
    override init() {
        self.bridgeConnector = BridgeConnector()
        super.init()
        self.bridgeConnector.bridge = self
    }
    
    func configureCustomRegIdentifiers(_ list: [String]) {
        self.customRegIdentifiers = list
    }
    
    func startOneginiModule(httpConnectionTimeout: TimeInterval = TimeInterval(5), callback: @escaping FlutterResult) {
        ONGClientBuilder().setHttpRequestTimeout(httpConnectionTimeout)
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start {
          result, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                callback(mappedError.flutterError())
                return
            }
            
            if !result {
                callback(SdkError(customType: .somethingWentWrong).flutterError())
                return
            }
            
            let profiles = ONGUserClient.sharedInstance().userProfiles()
            let value: [[String: String?]] = profiles.compactMap({ ["profileId": $0.profileId] })

            let data = String.stringify(json: value)
            
            callback(data)
        }
    }
    
    func fetchUserProfiles(callback: @escaping FlutterResult) {
        let profiles = ONGUserClient.sharedInstance().userProfiles()
        let value: [[String: String?]] = profiles.compactMap({ ["profileId": $0.profileId] })

        let data = String.stringify(json: value)
        
        callback(data)
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if let _value = eventSinkCustomIdentifier, let _arg = arguments as! String?, _value == _arg {
            self.eventSinkNativePart = events
        } else if let _arg = arguments as! String?, _arg == "onegini_events" {
            eventSink = events
        }
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void {
       debugPrint(eventName)
       if eventName == OneginiBridgeEvents.otpOpen {
           eventSinkNativePart?(data)
           return;
       }
       
       guard let _eventSink = eventSink else {
         return
       }
       
       _eventSink(data)
    }
}

