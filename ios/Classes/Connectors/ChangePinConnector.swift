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
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    var providePinChallenge: ProvidePinChallengeProtocol?
    var createPinChallenge: CreatePinChallengeProtocol?
    
    var changePinCallback: FlutterResult?
    
    init(changePinWrapper: ChangePinWrapperProtocol) {
        wrapper = changePinWrapper
        
        super.init()
        
        wrapper.providePin = onProvidePin
        wrapper.createPin = onCreatePin
        wrapper.changePinSuccess = onChangePinSuccess
        wrapper.changePinFailed = onChangePinFailed
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        changePinCallback = result
        
        wrapper.changePin()
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let challenge = providePinChallenge {
            challenge.cancel()
        }
        
        if let challenge = createPinChallenge {
            challenge.cancel()
        }
    }
    
    // callbacks
    func onProvidePin(challenge: ProvidePinChallengeProtocol) -> Void {
        providePinChallenge = challenge
        
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventOpenAutorizePin)
    }
    
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        createPinChallenge = challenge
        
        flutterConnector?.sendBridgeEvent(eventName: .pinNotification, data: Constants.Events.eventOpenCreatePin)
    }
    
    func onChangePinSuccess(userProfile: ONGUserProfile) -> Void {
        providePinChallenge = nil
        createPinChallenge = nil
        
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
