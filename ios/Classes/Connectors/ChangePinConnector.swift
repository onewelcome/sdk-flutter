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
    
    init(changePinWrapper: ChangePinWrapperProtocol) {
        wrapper = changePinWrapper
        
        super.init()
        
        wrapper.providePin = onProvidePin
        wrapper.createPin = onCreatePin
        wrapper.changePinSuccess = onChangePinSuccess
        wrapper.changePinFailed = onChangePinFailed
    }
    
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        wrapper.changePin()
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    // callbacks
    func onProvidePin(challenge: ProvidePinChallengeProtocol) -> Void {
        providePinChallenge = challenge
        // TODO: send info back to flutter
    }
    
    func onCreatePin(challenge: CreatePinChallengeProtocol) -> Void {
        createPinChallenge = challenge
        // TODO: send info back to flutter
    }
    
    func onChangePinSuccess(userProfile: ONGUserProfile) -> Void {
        providePinChallenge = nil
        createPinChallenge = nil
        // send info back to flutter
    }
    
    func onChangePinFailed(userProfile: ONGUserProfile, error: Error) -> Void {
        providePinChallenge = nil
        createPinChallenge = nil
        // send info back to flutter
    }
}
