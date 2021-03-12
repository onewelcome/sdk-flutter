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

public class OneginiModuleSwift: NSObject, ConnectorToFlutterBridgeProtocol, FlutterStreamHandler {
 
    var bridgeConnector: BridgeConnector
    private var eventSink: FlutterEventSink?
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
        super.init()
        self.bridgeConnector.bridge = self
    }
    
    public func configureCustomRegIdentifier(_ identifier: String) {
        self.customIdentifier = identifier
    }
    
    func supportedEvents() -> [String]! {
        return [OneginiBridgeEvents.pinNotification.rawValue]
    }
    
    func startOneginiModule(callback: @escaping FlutterResult) {
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
    
    public func otpResourceCodeConfirmation(code: String?, callback: @escaping FlutterResult) {
        
        bridgeConnector.toMobileAuthConnector.mobileAuthHandler.handleOTPMobileAuth(code ?? "", customRegistrationChallenge: bridgeConnector.toRegistrationConnector.registrationHandler.currentChallenge()) {
            (_ , error) -> Void in

            error != nil ? callback(error?.flutterError()) : callback(nil)
        }
    }
    
    public func getApplicationDetails(callback: @escaping FlutterResult) {
        self.bridgeConnector.toResourcesHandler.fetchAppDetails { (data, error) in
            error != nil ? callback(error?.flutterError()) : callback(data)
        }
    }
    
    public func fetchDevicesList(callback: @escaping FlutterResult) {
        self.bridgeConnector.toResourcesHandler.fetchDeviceList { (data, error) in
            error != nil ? callback(error?.flutterError()) : callback(data)
        }
    }

    public func fetchImplicitResources(callback: @escaping FlutterResult) {
        guard let _profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else { return }
        self.bridgeConnector.toResourcesHandler.fetchImplicitResources(profile: _profile) { (data, error) in
            error != nil ? callback(error?.flutterError()) : callback(data)
        }
    }
    
    func identityProviders(callback: @escaping FlutterResult) {
        let _providers = ONGClient.sharedInstance().userClient.identityProviders()
        let jsonData = _providers.compactMap { (identityProvider) -> [String: Any]? in
            var data = [String: Any]()
            data["id"] = identityProvider.identifier
            data["name"] = identityProvider.name
            return data
        }
        
        let data = String.stringify(json: jsonData)
        callback(data)
    }
    
    func logOut(callback: @escaping FlutterResult) {
        bridgeConnector.toLogoutUserInteractor.logout { (error) in
            error != nil ? callback(error?.flutterError()) : callback(true)
        }
    }
    
    func deregisterUser(callback: @escaping FlutterResult) {
        bridgeConnector.toDeregisterUserInteractor.disconnect { (error) in
            error != nil ? callback(SdkError.convertToFlutter(error)) : callback(true)
        }
    }
    
    func registerUser(_ identityProviderId: String? = nil, callback: @escaping FlutterResult) -> Void {

        bridgeConnector.toRegistrationConnector.registrationHandler.signUp(identityProviderId) {  (_, userProfile, error) -> Void in

            if let _userProfile = userProfile {
                callback(_userProfile.profileId)
            } else {
                callback(SdkError.convertToFlutter(error))
            }
        }
    }
    
    public func cancelRegistration() -> Void {
        bridgeConnector.toRegistrationConnector.registrationHandler.cancelRegistration()
    }
    
    func authenticateUser(_ profileId: String?,
                          callback: @escaping FlutterResult) -> Void {
        
        guard let profile: ONGUserProfile = ONGClient.sharedInstance().userClient.userProfiles().first else
        {
            callback(SdkError.convertToFlutter(SdkError.init(errorDescription: "User profile is null")))
            return
        }

        bridgeConnector.toLoginHandler.authenticateUser(profile) {
            (userProfile, error) -> Void in

            if let _userProfile = userProfile {
                callback(_userProfile.profileId)
            } else {
                callback(SdkError.convertToFlutter(error))
            }
        }
    }
    
     func handleRegistrationCallback(_ url: String) -> Void {
        guard let _url = URL(string: url) else { return }
        
        bridgeConnector.toRegistrationConnector.registrationHandler.processRedirectURL(url: _url)
     }
  
     func submitPinAction(_ action: String, isCreatePinFlow: Bool, pin: String) -> Void {
        bridgeConnector.toPinHandlerConnector.handlePinAction(action, isCreatePinFlow ? PinAction.provide.rawValue : PinAction.cancel.rawValue, pin)
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
    
    func fetchRegisteredAuthenticators(callback: @escaping FlutterResult) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError.init(errorDescription: "User profile is null")))
            return
        }
        
        let registeredAuthenticators = bridgeConnector.toAuthenticatorsHandler.getAuthenticatorsListForUserProfile(profile)
        
        let jsonData = registeredAuthenticators.compactMap { (registeredAuthenticator) -> [String: Any]? in
            var data = [String: Any]()
            data["id"] = registeredAuthenticator.identifier
            data["name"] = registeredAuthenticator.name
            return data
        }
        
        let data = String.stringify(json: jsonData)
        callback(data)
    }
    
    func registerFingerprintAuthenticator(callback: @escaping FlutterResult) -> Void {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            callback(SdkError.convertToFlutter(SdkError.init(errorDescription: "User profile is null")))
            return
        }
        
        let notRegisteredAuthenticators = ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: profile)
        
        if notRegisteredAuthenticators.count == 0 {
            callback(SdkError.convertToFlutter(SdkError.init(errorDescription: "Not registered authenticators is null")))
        }
        
        let isAuthenticatorRegistered = bridgeConnector.toAuthenticatorsHandler.isAuthenticatorRegistered(ONGAuthenticatorType.biometric, profile)
        
        guard isAuthenticatorRegistered else {
            callback(SdkError.convertToFlutter(SdkError.init(errorDescription: "Fingerprint authenticator is null")))
            return
        }

        bridgeConnector.toAuthenticatorsHandler.registerAuthenticator(profile, ONGAuthenticatorType.biometric) {
            (_ , error) -> Void in

            if let _error = error {
                callback(SdkError.convertToFlutter(_error))
            } else {
                callback(true)
            }
        }
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

