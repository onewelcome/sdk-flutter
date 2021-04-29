//
//  AuthenticationConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 25/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol AuthenticationConnectorProtocol: FlutterNotificationReceiverProtocol {
    func authenticate(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

class AuthenticationConnector: NSObject, AuthenticationConnectorProtocol {
    
    // references
    var wrapper: AuthenticationWrapperProtocol
    var authenticatorsConnector: AuthenticatorsConnectorProtocol
    var userProfileConnector: UserProfileConnectorProtocol
    
    unowned var flutterConnector: FlutterConnectorProtocol?
    
    // requests
    var pinAuthenticationRequest: PinRequestConnectorProtocol
    var biometricRequest: BiometricRequestConnectorProtocol
    
    // challanges
    var providePinChallenge: ProvidePinChallengeProtocol?
    var biometricChallenge: BiometricChallengeProtocol?
    
    // callbacks
    var authenticationCallback: FlutterResult?
    
    init(authenticationWrapper: AuthenticationWrapperProtocol, authenticators: AuthenticatorsConnectorProtocol, userProfile: UserProfileConnectorProtocol, pinAuthenticationRequest: PinRequestConnectorProtocol, biometricRequest: BiometricRequestConnectorProtocol) {
        wrapper = authenticationWrapper
        authenticatorsConnector = authenticators
        userProfileConnector = userProfile
        
        self.pinAuthenticationRequest = pinAuthenticationRequest
        self.biometricRequest = biometricRequest
        
        super.init()
        
        wrapper.providePin = onProvidePin
        wrapper.provideBiometric = onProvideBiometric
        wrapper.authorizationSuccess = onAuthorizationSuccess
        wrapper.authorizationFailed = onAuthorizationFailed
    }
    
    func authenticate(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if authenticationCallback != nil {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .actionInProgress))
            return
        }
        
        authenticationCallback = result
        
        var userId: String?
        var authenticatorId: String?
        
        if let arg = call.arguments as! [String: Any]? {
            userId = arg[Constants.Parameters.profileId] as? String
            authenticatorId = arg[Constants.Parameters.registeredAuthenticatorId] as? String
        }
        
        // TODO: user should pass userID to this method.
//        let user = userProfileConnector.getUserProfile(profileId: userId)
        // HACK: current workaround is to get first user
        let user = userProfileConnector.getUserProfiles().first
        guard user != nil else {
            result(FlutterError.configure(customType: .noUserAuthenticated))
            return
        }
        
        let authenticator = authenticatorsConnector.getAuthenticator(user: user!, authenticatorId: authenticatorId)
        wrapper.authenticateUser(user: user!, authenticator: authenticator)
    }
    
    func cancel(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        providePinChallenge?.cancel()
        providePinChallenge = nil
        pinAuthenticationRequest.removeListener(listener: self)
        
        biometricChallenge?.cancel()
        biometricChallenge = nil
        biometricRequest.removeListener(listener: self)
        
        authenticationCallback?(nil) // or should it send error?
        authenticationCallback = nil
        
        result(nil)
    }
    
    // callbacks
    func onProvidePin(challange: ProvidePinChallengeProtocol) -> Void {
        
        providePinChallenge = challange
        pinAuthenticationRequest.addListener(listener: self)
        
        // call flutter to open pin
        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenAutorizePin.rawValue)
    }
    
    func onProvideBiometric(challange: BiometricChallengeProtocol) -> Void {
        
        biometricChallenge = challange
        biometricRequest.addListener(listener: self)
        
        // call flutter to open biometric
        flutterConnector?.sendBridgeEvent(eventName: .registrationNotification, data: Constants.Events.eventOpenFingerprintAuth.rawValue)
    }
    
    func onAuthorizationSuccess(user: ONGUserProfile, authenticator: ONGAuthenticator, info: ONGCustomInfo?) -> Void {
        
        providePinChallenge = nil
        biometricChallenge = nil
        
        userProfileConnector.setAuthenticatedUser(authenticatedUser: user)
        
        authenticationCallback?(user.profileId)
        authenticationCallback = nil
    }
    
    func onAuthorizationFailed(user: ONGUserProfile, authenticator: ONGAuthenticator, error: Error) -> Void {
        
        providePinChallenge = nil
        biometricChallenge = nil
        
        authenticationCallback?(SdkError.init(errorDescription: error.localizedDescription, code: error.code).flutterError())
        authenticationCallback = nil
    }
}

extension AuthenticationConnector: PinListener {
    func acceptPin(pin: String) {
        pinAuthenticationRequest.removeListener(listener: self)
        guard let providePinChallenge = providePinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .providePinNotInProgress))
            return
        }
        
        providePinChallenge.respond(withPin: pin)
    }
    
    func denyPin() {
        pinAuthenticationRequest.removeListener(listener: self)
        guard let providePinChallenge = providePinChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .providePinNotInProgress))
            return
        }
        
        providePinChallenge.cancel()
    }
}

extension AuthenticationConnector: BiometricListener {
    func acceptBiometric(prompt: String) {
        biometricRequest.removeListener(listener: self)
        guard let biometricChallenge = biometricChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .biometricNotInProgress))
            return
        }
        
        biometricChallenge.respond(withPrompt: prompt)
    }
    
    func fallbackToPin() {
        biometricRequest.removeListener(listener: self)
        guard let biometricChallenge = biometricChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .biometricNotInProgress))
            return
        }
        
        biometricChallenge.respondWithPinFallback()
    }
    
    func denyBiometric() {
        biometricRequest.removeListener(listener: self)
        guard let biometricChallenge = biometricChallenge else {
            flutterConnector?.sendBridgeEvent(eventName: .errorNotification, data: FlutterError.configure(customType: .biometricNotInProgress))
            return
        }
        
        biometricChallenge.cancel()
    }
}
