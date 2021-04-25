//
//  RegistrationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol RegistrationConnectorProtocol: FlutterNotificationReceiverProtocol {
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class NewRegistrationConnector: NSObject, RegistrationConnectorProtocol {
    
    // references
    var wrapper: RegistrationWrapperProtocol
    var identityProviderConnector: IdentityProviderConnectorProtocol
    var userProfileConnector: UserProfileConnectorProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    // requests
    var browserRegistrationRequest: BrowserRequestConnectorProtocol
    var pinRegistrationRequest: PinRequestConnectorProtocol
    
    // challanges
    var browserRegistrationChallenge: BrowserRegistrationChallengeProtocol?
    var createPinChallenge: CreatePinChallengeProtocol?
    
    // callbacks
    var registrationCallback: FlutterResult?
    
    init(registrationWrapper: RegistrationWrapperProtocol, identityProvider: IdentityProviderConnectorProtocol, userProfile: UserProfileConnectorProtocol, browserRegistrationRequest: BrowserRequestConnectorProtocol, pinRegistrationRequest: PinRequestConnectorProtocol) {
        wrapper = registrationWrapper
        identityProviderConnector = identityProvider
        userProfileConnector = userProfile
        
        self.browserRegistrationRequest = browserRegistrationRequest
        self.pinRegistrationRequest = pinRegistrationRequest
        
        super.init()
        
        wrapper.browserRegistration = onBrowserRegistration
        wrapper.createPin = onCreatePin
        wrapper.registrationSuccess = onRegistrationSuccess
        wrapper.registrationFailed = onRegistrationFailed
    }
    
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        if registrationCallback != nil {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .actionInProgress))
            return
        }
        registrationCallback = result
        
        var providerId: String?
        var scopes: Array<String>?
        
        if let arg = call.arguments as! [String: Any]? {
            providerId = arg[Constants.Parameters.identityProviderId] as? String
            scopes = arg[Constants.Parameters.scopes] as? Array<String>
        }
        
        let identityProvider = identityProviderConnector.getIdentityProvider(providerId: providerId)
        wrapper.register(identityProvider: identityProvider, scopes: scopes)
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        browserRegistrationChallenge?.cancel()
        browserRegistrationChallenge = nil
        browserRegistrationRequest.removeListener(listener: self)
        
        createPinChallenge?.cancel()
        createPinChallenge = nil
        pinRegistrationRequest.removeListener(listener: self)
        
        registrationCallback?(nil) // or should it send error?
        registrationCallback = nil
        
        result(nil)
    }
    
    // callbacks
    func onBrowserRegistration(challenge: BrowserRegistrationChallengeProtocol) -> Void {
        browserRegistrationChallenge = challenge
        
        browserRegistrationRequest.addListener(listener: self)
        
        // TODO: remove this after finishing with new browser connector
        let browser = BrowserViewController(registerHandlerProtocol: self)
        browser.handleUrl(url: challenge.getUrl())
        
        // TODO: uncomment this section when new pin flow will be implemented
        // return url back to flutter
//        var data: [String: Any] = [:]
//        data[Constants.Parameters.eventName] = Constants.Events.eventOpenUrl.rawValue
//        data[Constants.Parameters.eventValue] = challenge.getUrl().absoluteString
//
//        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: String.stringify(json: data))
    }
    
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        createPinChallenge = challenge
        
        pinRegistrationRequest.addListener(listener: self)
        
        // send event back to flutter to open pin creation
        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenCreatePin.rawValue)
    }
    
    func onRegistrationSuccess(userProfile: ONGUserProfile, info: ONGCustomInfo?) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
        userProfileConnector.setAuthenticatedUser(authenticatedUser: userProfile)
        
        registrationCallback?(userProfile.profileId)
        registrationCallback = nil
    }
    
    func onRegistrationFailed(error: Error) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
        registrationCallback?(SdkError.init(errorDescription: error.localizedDescription, code: error.code).flutterError())
        registrationCallback = nil
    }
}

extension NewRegistrationConnector: BrowserListener {
    func acceptUrl(url: URL) {
        browserRegistrationRequest.removeListener(listener: self)
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .browserRegistrationNotInProgress))
            return
        }
        
        browserRegistrationChallenge.respond(withUrl: url)
    }
    
    func denyUrl() {
        browserRegistrationRequest.removeListener(listener: self)
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .browserRegistrationNotInProgress))
            return
        }
        
        browserRegistrationChallenge.cancel()
    }
}

extension NewRegistrationConnector: PinListener {
    func acceptPin(pin: String) {
        pinRegistrationRequest.removeListener(listener: self)
        guard let createPinChallenge = createPinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .createPinNotInProgress))
            return
        }
        
        createPinChallenge.respond(withPin: pin)
    }
    
    func denyPin() {
        pinRegistrationRequest.removeListener(listener: self)
        guard let createPinChallenge = createPinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .createPinNotInProgress))
            return
        }
        
        createPinChallenge.cancel()
    }
}

// TODO: remove after implementing new browser connector
extension NewRegistrationConnector: BrowserHandlerToRegisterHandlerProtocol {
    func handleRedirectURL(url: URL?) {
        guard let browserRegistrationChallenge = browserRegistrationChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .browserRegistrationNotInProgress))
            return
        }
        
        if let url = url {
            browserRegistrationChallenge.respond(withUrl: url)
        } else {
            browserRegistrationChallenge.cancel()
        }
    }
}
