//
//  OneginiConnector.swift
//  onegini
//
//  Created by Patryk Gałach on 20/04/2021.
//


// MARK: SDK connector protocol
protocol OneginiConnectorProtocol {
    // base
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // registration
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // user
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // authenticator
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // pin
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // fingerprint
    func acceptFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func fingerprintFallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // custom
    func customTwoStepRegistrationReturnSuccess(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func customTwoStepRegistrationReturnError(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // otp
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // resources
    func getResourceAnonymous(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getImplicitResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func unauthenticatedRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // app to web
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
}

// MARK: Connector Implementation
class OneginiConnector: NSObject, OneginiConnectorProtocol {
    
    unowned var flutterConnector: FlutterConnectorProtocol
    
    var startAppConnector: StartAppConnectorProtocol?
    var registrationConnector: RegistrationConnectorProtocol?
//    var pinConnector: PinConnectorProtocol?
    var changePinConnector: ChangePinConnectorProtocol?
    
    init(flutterConnector: FlutterConnectorProtocol) {
        self.flutterConnector = flutterConnector
        
        startAppConnector = StartAppConnector.init(startAppWrapper: StartAppWrapper())

        registrationConnector = NewRegistrationConnector.init(registrationWrapper: RegistrationWrapper())
//        registrationConnector?.flutterConnector = flutterConnector

//        pinConnector = NewPinConnector.init(pinWrapper: PinWrapper())
//        pinConnector.flutterConnector = flutterConnector
        
        changePinConnector = ChangePinConnector.init(changePinWrapper: ChangePinWrapper())
        changePinConnector?.flutterConnector = flutterConnector
    }
    
    func startApp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        startAppConnector?.startApp(call, result)
    }
    
    func registerUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        registrationConnector?.register(call, result)
    }
    
    func cancelRegistration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        registrationConnector?.cancel(call, result)
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func acceptFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func denyFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func fingerprintFallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func customTwoStepRegistrationReturnSuccess(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func customTwoStepRegistrationReturnError(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getResourceAnonymous(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getImplicitResource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func unauthenticatedRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func getAppToWebSingleSignOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    
}
