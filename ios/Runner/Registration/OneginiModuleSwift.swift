import Foundation
import OneginiSDKiOS
import Flutter

protocol ConnectorToRNBridgeProtocol: NSObject {
  func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void
}

enum OneginiBridgeEvents : String {
    case pinNotification = "ONEGINI_PIN_NOTIFICATION"
}

class OneginiModuleSwift: NSObject, ConnectorToRNBridgeProtocol {
 
    // Pin test default value
    static let pinTestValue: String = "55668"
    
    var bridgeConnector: BridgeConnector

    static let sharedInstance = OneginiModuleSwift()
    
    override init() {
        self.bridgeConnector = BridgeConnector()
        super.init()
        self.bridgeConnector.bridge = self
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
    
    func getResources(callback: @escaping FlutterResult) {
        let request = ONGRequestBuilder()
            .setMethod("GET")
            .setPath("/application-details")
            .build()
        ONGClientBuilder().build()
      
        ONGClientBuilder().build()
        ONGDeviceClient.sharedInstance().fetchUnauthenticatedResource(request!) { response, error in
            if response!.statusCode < 400, let data = response?.data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                callback(json)

            } catch {
                print("not json")
            }

          } else {
            print(error.debugDescription)
          }
        }
    }
    
    func registerUser(_ identityProviderId: NSString? = nil, callback: @escaping FlutterResult) -> Void {
        bridgeConnector.toRegistrationHandler.signUp {
          (_, userProfile, error) -> Void in
          
            if let userProfile = userProfile {
                //TODO: User is able to modify the content format, which will be returned to the Flutter environment
                //callback([["success" : true, "profileId" : userProfile.profileId!]])
                callback(userProfile.profileId)
            } else {
                //callback([["success" : false, "errorMsg" : error?.errorDescription ?? "Unexpected Error."]])
                callback(FlutterError(code: "401", message: error?.errorDescription  ?? "Unexpected Error.", details: nil))
            }
          
        }
    }
    
    func handleRegistrationCallback(_ url: (NSString)) -> Void {
        bridgeConnector.toRegistrationHandler.handleRedirectURL(url: URL(string: url as String)!)
    }
    
    func cancelRegistration() -> Void {
        bridgeConnector.toRegistrationHandler.cancelRegistration()
    }
  
    func submitPinAction(_ action: (NSString), isCreatePinFlow: (NSNumber), pin: (NSString)) -> Void {
        bridgeConnector.toChangePinConnector.handlePinAction(action, isCreatePinFlow, pin)
    }
    
    func sendBridgeEvent(eventName: OneginiBridgeEvents, data: Any!) -> Void {
        debugPrint(sendBridgeEvent)
        //@todo User is able to modify content format, which will be returns to Flutter environment
        //self.sendEvent(withName: eventName.rawValue, body: data)
    }

}
