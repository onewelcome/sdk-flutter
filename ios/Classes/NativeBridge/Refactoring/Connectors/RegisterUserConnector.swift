//
//  RegisterUserConnector.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
import OneginiSDKiOS
import OneginiCrypto
import Flutter

protocol RegisterUserConnectorProtocol {
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class RegisterUserConnector: NSObject, RegisterUserConnectorProtocol, FlutterNotificationReceiverProtocol {

    var wrapper: RegisterUserWrapperProtocol!
    weak var flutterConnector: FlutterConnectorProtocol?
//    weak var pinConnector: PinConnectorProtocol?
//    var identityProviderConnector: IdentityProviderConnectorProtocol

    // challanges
    var browserRegistrationChallenge: BrowserRegistrationChallengeProtocol?
    var createPinChallenge: CreatePinChallengeProtocol?
    
    // callbacks
    var registrationCallback: FlutterResult?
    
    init(registrationWrapper: RegisterUserWrapperProtocol,
         //identityProvider: IdentityProviderConnectorProtocol,
         //browserWrapper: BrowserWrapperProtocol?,
         /*pinConnector: PinConnectorProtocol?*/) {
        
        wrapper = registrationWrapper
        
//        identityProviderConnector = identityProvider
//
//        self.browserWrapper = browserWrapper
//        self.pinConnector = pinConnector
        
        super.init()
        
        wrapper.browserRegistrationCallback = onBrowserRegistration
        wrapper.createPinCallback = onCreatePin
        wrapper.registrationSuccessCallback = onRegistrationSuccess
        wrapper.registrationFailedCallback = onRegistrationFailed
    }
    
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
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
        
        createPinChallenge?.cancel()
        createPinChallenge = nil
        pinConnector = nil
        
        registrationCallback?(nil)
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
}

//MARK: Callbacks
extension RegisterUserConnector {
        func onBrowserRegistration(challenge: BrowserRegistrationChallengeProtocol) -> Void {
            browserRegistrationChallenge = challenge

            // return url back to flutter
            var data: [String: String] = [:]
            data[Constants.Parameters.eventName] = OneginiPluginEvents.handleRegisteredUrl.rawValue
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


