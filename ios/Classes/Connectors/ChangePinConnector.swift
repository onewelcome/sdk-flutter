//
//  ChangePinConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol ChangePinConnectorProtocol: FlutterNotificationReceiverProtocol {
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class ChangePinConnector: NSObject, ChangePinConnectorProtocol {
    
    var wrapper: ChangePinWrapperProtocol
    var identityProviderConnector: IdentityProviderConnectorProtocol
    var pinAuthenticationRequest: PinRequestConnectorProtocol
    var pinCreationRequest: PinRequestConnectorProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var providePinChallenge: ProvidePinChallengeProtocol?
    var createPinChallenge: CreatePinChallengeProtocol?
    
    var changePinCallback: FlutterResult?
    
    var isAutorized: Bool = false
    
    init(changePinWrapper: ChangePinWrapperProtocol, identityProvider: IdentityProviderConnectorProtocol, pinAuthenticationRequest: PinRequestConnectorProtocol, pinCreationRequest: PinRequestConnectorProtocol) {
        wrapper = changePinWrapper
        identityProviderConnector = identityProvider
        self.pinAuthenticationRequest = pinAuthenticationRequest
        self.pinCreationRequest = pinCreationRequest
        
        super.init()
        
        wrapper.providePin = onProvidePin
        wrapper.createPin = onCreatePin
        wrapper.changePinSuccess = onChangePinSuccess
        wrapper.changePinFailed = onChangePinFailed
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        if changePinCallback != nil {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .actionInProgress))
            return
        }
        changePinCallback = result
        
        isAutorized = false
        wrapper.changePin()
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        providePinChallenge?.cancel()
        providePinChallenge = nil
        pinAuthenticationRequest.removeListener(listener: self)
        
        createPinChallenge?.cancel()
        createPinChallenge = nil
        pinCreationRequest.removeListener(listener: self)
        
        changePinCallback?(nil) // or should it send error?
        changePinCallback = nil
        
        result(nil)
    }
    
    // callbacks
    func onProvidePin(challenge: ProvidePinChallengeProtocol) -> Void {
        
        providePinChallenge = challenge
        
        pinAuthenticationRequest.addListener(listener: self)
        
        // send event to open pin authentication
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventOpenAutorizePin.rawValue)
    }
    
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        
        isAutorized = true
        createPinChallenge = challenge
        
        pinCreationRequest.addListener(listener: self)
        
        // send event to close pin authentication and open pin creation
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventCloseAutorizePin.rawValue)
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventOpenCreatePin.rawValue)
    }
    
    func onChangePinSuccess(userProfile: ONGUserProfile) -> Void {
        
        providePinChallenge = nil
        createPinChallenge = nil
        
        // send event to close pin creation
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventCloseCreatePin.rawValue)
        
        // send info back to flutter
        changePinCallback?(true)
        changePinCallback = nil
    }
    
    func onChangePinFailed(userProfile: ONGUserProfile, error: Error) -> Void {
        
        providePinChallenge = nil
        createPinChallenge = nil
        
        // send info back to flutter
        changePinCallback?(SdkError.init(errorDescription: error.localizedDescription, code: error.code).flutterError())
        changePinCallback = nil
    }
}

extension ChangePinConnector: PinListener {
    func acceptPin(pin: String) {
        if !isAutorized {
            // first need to be authorized
            pinAuthenticationRequest.removeListener(listener: self)
            guard let challenge = providePinChallenge else {
                flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .providePinNotInProgress))
                return
            }
            
            challenge.respond(withPin: pin)
        } else {
            pinCreationRequest.removeListener(listener: self)
            guard let challenge = createPinChallenge else {
                flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .createPinNotInProgress))
                return
            }
            
            challenge.respond(withPin: pin)
        }
    }
    
    func denyPin() {
        if !isAutorized {
            // first need to be authorized
            pinAuthenticationRequest.removeListener(listener: self)
            guard let challenge = providePinChallenge else {
                flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .providePinNotInProgress))
                return
            }
            
            challenge.cancel()
        } else {
            pinCreationRequest.removeListener(listener: self)
            guard let challenge = createPinChallenge else {
                flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: SdkError.init(customType: .createPinNotInProgress))
                return
            }
            
            challenge.cancel()
        }
    }
    
}
