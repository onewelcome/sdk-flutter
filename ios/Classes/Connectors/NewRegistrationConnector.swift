//
//  RegistrationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import Foundation

import OneginiSDKiOS

//MARK:- RegistrationConnectorProtocol
protocol RegistrationConnectorProtocol: FlutterNotificationReceiverProtocol {
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

//MARK: RegistrationConnectorProtocol
class NewRegistrationConnector: NSObject, RegistrationConnectorProtocol {
    
    // references
    var wrapper: RegistrationWrapperProtocol
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    // requests
    weak var browserWrapper: BrowserWrapperProtocol?
    weak var pinConnector: PinConnectorProtocol?
    var identityProviderConnector: IdentityProviderConnectorProtocol

    
    // challanges
    var browserRegistrationChallenge: BrowserRegistrationChallengeProtocol?
    var createPinChallenge: CreatePinChallengeProtocol?
    
    // callbacks
    var registrationCallback: FlutterResult?
    
    init(registrationWrapper: RegistrationWrapperProtocol,
         identityProvider: IdentityProviderConnectorProtocol,
         browserWrapper: BrowserWrapperProtocol?,
         pinConnector: PinConnectorProtocol?) {
        
        wrapper = registrationWrapper
        
        identityProviderConnector = identityProvider
        
        self.browserWrapper = browserWrapper
        self.pinConnector = pinConnector
        
        super.init()
        
        wrapper.browserRegistration = onBrowserRegistration
        wrapper.createPin = onCreatePin
        wrapper.registrationSuccess = onRegistrationSuccess
        wrapper.registrationFailed = onRegistrationFailed
    }
    
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        if registrationCallback != nil {
            result(FlutterError.configure(customType: .actionInProgress))
            return
        }
        registrationCallback = result
        
        var providerId: String?
        var scopes: Array<String>?
        
        if let arg = call.arguments as! [String: Any]? {
            providerId = arg[Constants.Parameters.identityProviderId] as? String
            scopes = arg[Constants.Parameters.scopes] as? Array<String>
        }
        
        let identityProvider = identityProviderConnector.getIdentityProviderWith(providerId: providerId)
        wrapper.register(identityProvider: identityProvider, scopes: scopes)
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        browserRegistrationChallenge?.cancel()
        browserRegistrationChallenge = nil
        browserWrapper = nil
        
        createPinChallenge?.cancel()
        createPinChallenge = nil
        pinConnector = nil
        
        registrationCallback?(nil) //FIXME: Need to check should it send error
        registrationCallback = nil
        
        result(nil)
    }
    
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let _ = registrationCallback else {
            result(FlutterError.configure(customType: .newSomethingWentWrong))
            return
        }
        
        var url: URL?
        var typeValue: Int?
        
        if let _arg = call.arguments as! [String: Any]? {
            let urlPath = _arg[Constants.Parameters.url] as? String
            typeValue = _arg[Constants.Parameters.type] as! Int?
            
            if let urlPath = urlPath {
                url = URL.init(string: urlPath)
            }
        }
        
        var type: WebSignInType = .insideApp
        if let typeValue = typeValue, let value = WebSignInType.init(rawValue: typeValue) {
            type = value
        }
        
        guard let regUrl = url else {
            result(FlutterError.configure(customType: .invalidUrl))
            return
        }

        let browser = BrowserViewController(registerHandlerProtocol: self)
        browser.handleUrl(url: regUrl, webSignInType: type)
    }
    
    // callbacks
    func onBrowserRegistration(challenge: BrowserRegistrationChallengeProtocol) -> Void {
        browserRegistrationChallenge = challenge
        
        browserWrapper = self
        
        // return url back to flutter
        var data: [String: String] = [:]
        data[Constants.Parameters.eventName] = Constants.Events.eventHandleRegisteredUrl.rawValue
        data[Constants.Parameters.eventValue] = challenge.getUrl().absoluteString

        flutterConnector?.sendBridgeEvent(eventName: .handleRegisteredUrl, data: String.stringify(json: data))
    }
    
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        createPinChallenge = challenge
        
        pinConnector?.configure(wrapper: self)
        
        // send event back to flutter to open pin creation
        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenCreatePin.rawValue)
    }
    
    func onRegistrationSuccess(userProfile: ONGUserProfile, info: ONGCustomInfo?) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
        var result = Dictionary<String, Any?>()
        result[Constants.Parameters.userProfile] = [Constants.Parameters.profileId: userProfile.profileId]
        
        if let userInfo = info {
            result[Constants.Parameters.customInfo] = [Constants.Parameters.status: userInfo.status, Constants.Parameters.data: userInfo.data]
        }
        
        registrationCallback?(String.stringify(json: result))
        registrationCallback = nil
    }
    
    func onRegistrationFailed(error: Error) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
        registrationCallback?(FlutterError.configure(error: error))
        registrationCallback = nil
    }
}

//MARK: BrowserWrapperProtocol
extension NewRegistrationConnector: BrowserWrapperProtocol {
    func acceptUrl(url: URL) {
        browserWrapper = nil
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .browserRegistrationNotInProgress))
            return
        }
        
        browserRegistrationChallenge.respond(withUrl: url)
    }
    
    func denyUrl() {
        browserWrapper = nil
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .browserRegistrationNotInProgress))
            return
        }
        
        browserRegistrationChallenge.cancel()
    }
}

//MARK: PinWrapperProtocol
extension NewRegistrationConnector: PinWrapperProtocol {
    func acceptPin(pin: String) {
        pinConnector?.configure(wrapper: self)
        guard let createPinChallenge = createPinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .createPinNotInProgress))
            return
        }
        
        createPinChallenge.respond(withPin: pin)
    }
    
    func denyPin() {
        pinConnector?.configure(wrapper: nil)
        guard let createPinChallenge = createPinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .createPinNotInProgress))
            return
        }
        
        createPinChallenge.cancel()
    }
}

// TODO: remove after implementing new browser connector
// Call from browser controller
extension NewRegistrationConnector: BrowserHandlerToRegisterHandlerProtocol {
    func handleRedirectURL(url: URL?) {
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .browserRegistrationNotInProgress))
            return
        }
        
        if let url = url {
            browserRegistrationChallenge.respond(withUrl: url)
        } else {
            browserRegistrationChallenge.cancel()
        }
    }
}


//MARK: -
//MARK: - PinConnectorProtocol
protocol PinConnectorProtocol: class {
    func acceptPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func configure(wrapper pinWrapper: PinWrapperProtocol?)
}

//MARK: - PinWrapperProtocol
protocol PinWrapperProtocol: class {
    func acceptPin(pin: String)
    func denyPin()
}

//MARK: - PinConnector
class NewPinConnector: PinConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    weak var delegatePinWrapper: PinWrapperProtocol? = nil
    
    //MARK: PinConnectorProtocol
    func configure(wrapper pinWrapper: PinWrapperProtocol?) {
        self.delegatePinWrapper = pinWrapper
    }
    
    func acceptPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var pin: String?
        
        if let arg = call.arguments as! [String: Any]? {
            pin = arg[Constants.Parameters.pin] as? String
        }
        
        guard let p = pin else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .invalidArguments))
            result(nil)
            return
        }
        
        self.delegatePinWrapper?.acceptPin(pin: p)

        result(nil)
    }
    
    func denyPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        self.delegatePinWrapper?.denyPin()
        
        result(nil)
    }
}

//MARK: -
//MARK: - BrowserConnectorProtocol
protocol BrowserWrapperProtocol: class {
    func acceptUrl(url: URL)
    func denyUrl()
}

protocol BrowserConnectorProtocol {
    func acceptUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class BrowserConnector: BrowserConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    weak var delegateBrowserWrapper: BrowserWrapperProtocol? = nil
    
    func configure(delegate browserWrapper: BrowserWrapperProtocol?) {
        self.delegateBrowserWrapper = browserWrapper
    }
    
    //MARK:
    func acceptUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        var urlPath: String?
        
        if let arg = call.arguments as! [String: Any]? {
            urlPath = arg[Constants.Parameters.url] as? String
        }
        
        guard let url = URL.init(string: urlPath ?? "") else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .invalidArguments))
            result(nil)
            return
        }
        
        self.delegateBrowserWrapper?.acceptUrl(url: url)
        
        result(nil)
    }
    
    func denyUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        self.delegateBrowserWrapper?.denyUrl()
        
        result(nil)
    }
}

//MARK:- UserProfileWrapperProtocol
protocol UserProfileWrapperProtocol: class {
    func getAuthenticatedUser() -> ONGUserProfile?
    func getUserProfiles() -> Array<ONGUserProfile>
    func getUserProfile(profileId: String?) -> ONGUserProfile?
}

class UserProfileWrapper: UserProfileWrapperProtocol {
    
    func getAuthenticatedUser() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func getUserProfiles() -> Array<ONGUserProfile> {
        
        let profiles = Array(ONGUserClient.sharedInstance().userProfiles())
        return profiles
    }
    
    func getUserProfile(profileId: String?) -> ONGUserProfile? {
        let profiles = getUserProfiles()
        let profile = profiles.first(where: { $0.profileId == profileId})
        return profile
    }
}

//MARK:- NewUserProfileConnectorProtocol
protocol NewUserProfileConnectorProtocol: class {
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class NewUserProfileConnector: NewUserProfileConnectorProtocol {
    weak var userProfileWrapper: UserProfileWrapperProtocol!
    
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let profiles = self.userProfileWrapper.getUserProfiles()
        let jsonData: [[String: String]] = profiles.compactMap({ ["profileId" : $0.profileId] })
        
        let data = String.stringify(json: jsonData)
        result(data)
    }
}
