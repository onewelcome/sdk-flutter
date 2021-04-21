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
    
    var wrapper: RegistrationWrapperProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var createPinChallenge: CreatePinChallengeProtocol?
    var browserRegistrationChallenge: BrowserRegistrationChallengeProtocol?
    
    var registrationCallback: FlutterResult?
    
    init(registrationWrapper: RegistrationWrapperProtocol) {
        wrapper = registrationWrapper
        
        super.init()
        
        wrapper.createPin = onCreatePin
        wrapper.browserRegistration = onBrowserRegistration
        wrapper.registrationSuccess = onRegistrationSuccess
        wrapper.registrationFailed = onRegistrationFailed
    }
    
    func register(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        registrationCallback = result
        
        var providerId: String?
        var scopes: Array<String>?
        
        if let arg = call.arguments as! [String: Any]? {
            providerId = arg[Constants.Parameters.identityProviderId] as? String
            scopes = arg[Constants.Parameters.scopes] as? Array<String>
        }
        
        // TODO: don't call SDK directly
        let identityProviders = Array(ONGUserClient.sharedInstance().identityProviders())
        var identityProvider = identityProviders.first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        wrapper.register(identityProvider: identityProvider, scopes: scopes)
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let challenge = createPinChallenge {
            challenge.cancel()
        }
        
        if let challenge = browserRegistrationChallenge {
            challenge.cancel()
        }
    }
    
    // callbacks
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        createPinChallenge = challenge
        
        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenCreatePin)
    }
    
    func onBrowserRegistration(challenge: BrowserRegistrationChallengeProtocol) -> Void {
        browserRegistrationChallenge = challenge
        
        // TODO: remove this after finishing with new browser connector
        let browser = BrowserViewController(registerHandlerProtocol: self)
        browser.handleUrl(url: challenge.getUrl())
        
        // TODO: return url back to flutter
//        var data: [String: Any] = [:]
//        data[Constants.Parameters.eventName] = Constants.Events.eventOpenUrl
//        data[Constants.Parameters.eventValue] = challenge.getUrl().absoluteString
//
//        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: String.stringify(json: data))
    }
    
    func onRegistrationSuccess(userProfile: ONGUserProfile, info: ONGCustomInfo?) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
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

// TODO: remove after implementing new browser connector
extension NewRegistrationConnector: BrowserHandlerToRegisterHandlerProtocol {
    func handleRedirectURL(url: URL?) {
        if let url = url {
            browserRegistrationChallenge?.respond(withUrl: url)
        }
        else {
            browserRegistrationChallenge?.cancel()
        }
    }
}
