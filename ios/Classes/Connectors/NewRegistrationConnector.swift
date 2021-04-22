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
    var pinConnector: PinConnectorToPinHandler
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    // challanges
    var createPinChallenge: CreatePinChallengeProtocol?
    var browserRegistrationChallenge: BrowserRegistrationChallengeProtocol?
    
    // callbacks
    var registrationCallback: FlutterResult?
    
    init(registrationWrapper: RegistrationWrapperProtocol, identityProvider: IdentityProviderConnectorProtocol, pinHandler: PinConnectorToPinHandler) {
        wrapper = registrationWrapper
        identityProviderConnector = identityProvider
        pinConnector = pinHandler
        
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
        
        let identityProvider = identityProviderConnector.getIdentityProvider(providerId: providerId)
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
        
        // TODO: remove this after finishing with new pin handling connector
        pinConnector.handleFlowUpdate(.create, nil, receiver: self)
        
        // TODO: uncomment this section when new pin flow will be implemented
        // send event back to flutter to open pin creation
//        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenCreatePin)
    }
    
    func onBrowserRegistration(challenge: BrowserRegistrationChallengeProtocol) -> Void {
        browserRegistrationChallenge = challenge
        
        // TODO: remove this after finishing with new browser connector
        let browser = BrowserViewController(registerHandlerProtocol: self)
        browser.handleUrl(url: challenge.getUrl())
        
        // TODO: uncomment this section when new pin flow will be implemented
        // return url back to flutter
//        var data: [String: Any] = [:]
//        data[Constants.Parameters.eventName] = Constants.Events.eventOpenUrl
//        data[Constants.Parameters.eventValue] = challenge.getUrl().absoluteString
//
//        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: String.stringify(json: data))
    }
    
    func onRegistrationSuccess(userProfile: ONGUserProfile, info: ONGCustomInfo?) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        pinConnector.closeFlow()
        
        registrationCallback?(userProfile.profileId)
        registrationCallback = nil
    }
    
    func onRegistrationFailed(error: Error) -> Void {
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        pinConnector.closeFlow()
        
        registrationCallback?(SdkError.init(errorDescription: error.localizedDescription, code: error.code).flutterError())
        registrationCallback = nil
    }
}

// TODO: remove this after finishing with new pin handling connector
extension NewRegistrationConnector: PinHandlerToReceiverProtocol {
    func handlePin(pin: String?) {
        guard let createPinChallenge = createPinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .createPinNotInProgress))
            return
        }
        
        if let pin = pin {
            createPinChallenge.respond(withPin: pin)
        } else {
            createPinChallenge.cancel()
        }
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
