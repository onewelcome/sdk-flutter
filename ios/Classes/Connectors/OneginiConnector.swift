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
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // authentication
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func cancelAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // user
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // providers
    func identityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // authenticators
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    // authenticator registration
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
    func acceptOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    func denyOtpAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
    func handleMobileAuthWithOtp(_ call: FlutterMethodCall, _ result: @escaping FlutterResult)
    
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
    
    // providers
    var identityProviderConnector: IdentityProviderConnectorProtocol?
    var userProfileConnector: UserProfileConnectorProtocol?
    
    // requests
    var browserRequest: BrowserRequestConnectorProtocol?
    var pinRegistrationRequest: PinRequestConnectorProtocol?
    var pinAuthenticationRequest: PinRequestConnectorProtocol?
    var biometricRequest: BiometricRequestConnectorProtocol?
    
    // connectors
    var startAppConnector: StartAppConnectorProtocol?
    
    var registrationConnector: RegistrationConnectorProtocol?
    var pinValidationConnector: PinValidationConnectorProtocol?
    
    var authenticatorsConnector: AuthenticatorsConnectorProtocol?
    var authenticatorRegistrationConnector: AuthenticatorRegistrationConnectorProtocol?
    var authenticationConnector: AuthenticationConnectorProtocol?
    
    var changePinConnector: ChangePinConnectorProtocol?
    
    var browseWrapper: BrowserWrapperProtocol? = nil
    var pinConnector: PinConnectorProtocol? = nil
    
    init(flutterConnector: FlutterConnectorProtocol) {
        self.flutterConnector = flutterConnector
        
        identityProviderConnector = IdentityProviderConnector(identityProviderWrapper: IdentityProviderWrapper())
        userProfileConnector = UserProfileConnector()
        
        
        browserRequest = BrowserRequestConnector()
        pinRegistrationRequest = PinRequestConnector()
        pinAuthenticationRequest = PinRequestConnector()
        biometricRequest = BiometricRequestConnector()
        
        // ***
//        browseWrapper = nil
        pinConnector = NewPinConnector()
        // ***
        
        startAppConnector = StartAppConnector.init(startAppWrapper: StartAppWrapper(), userProfileConnector: userProfileConnector!)

        registrationConnector = NewRegistrationConnector.init(registrationWrapper: RegistrationWrapper(), identityProvider: identityProviderConnector!, browserWrapper: browseWrapper, pinConnector: pinConnector)
        
//        registrationConnector = NewRegistrationConnector.init(registrationWrapper: RegistrationWrapper(), identityProvider: identityProviderConnector!, userProfile: userProfileConnector!, browserRegistrationRequest: browserRequest!, pinRegistrationRequest: pinRegistrationRequest!)
        registrationConnector?.flutterConnector = flutterConnector

        authenticatorsConnector = AuthenticatorsConnector.init(authenticatorsWrapper: AuthenticatorsWrapper(), userProfileConnector: userProfileConnector!)
        
        authenticatorRegistrationConnector = AuthenticatorRegistrationConnector.init(registrationWrapper: AuthenticatorRegistrationWrapper(), deregistrationWrapper: AuthenticatorDeregistrationWrapper(), userProfileConnector: userProfileConnector!, authenticatorsConnector: authenticatorsConnector!)
        
        authenticationConnector = AuthenticationConnector.init(authenticationWrapper: AuthenticationWrapper(), authenticators: authenticatorsConnector!, userProfile: userProfileConnector!, pinAuthenticationRequest: pinAuthenticationRequest!, biometricRequest: biometricRequest!)
        authenticationConnector?.flutterConnector = flutterConnector
        
        changePinConnector = ChangePinConnector.init(changePinWrapper: ChangePinWrapper(), identityProvider: identityProviderConnector!, pinAuthenticationRequest: pinAuthenticationRequest!, pinCreationRequest: pinRegistrationRequest!)
        changePinConnector?.flutterConnector = flutterConnector
        
        pinValidationConnector = PinValidationConnector()
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
    
    func handleRegisteredProcessUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        registrationConnector?.handleRegisteredProcessUrl(call, result)
    }
    
    func deregisterUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    func userProfiles(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        userProfileConnector?.userProfiles(call, result)
    }
    
    func authenticateUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticationConnector?.authenticate(call, result)
    }
    
    func cancelAuthentication(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticationConnector?.cancel(call, result)
    }
    
    func logout(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        fatalError("not implemented")
    }
    
    //FIXME: change name to get...
    func identityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        identityProviderConnector?.getIdentityProviders(call, result)
    }
    
    func setPreferredAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticatorsConnector?.setPreferredAuthenticator(call, result)
    }
    
    func getRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticatorsConnector?.getRegisteredAuthenticators(call, result)
    }
    
    func getAllNotRegisteredAuthenticators(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticatorsConnector?.getAllNotRegisteredAuthenticators(call, result)
    }
    
    func registerAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticatorRegistrationConnector?.registerAuthenticator(call, result)
    }
    
    func deregisterAuthenticator(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        authenticatorRegistrationConnector?.deregisterAuthenticator(call, result)
    }
    
    func acceptPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        //TODO: Need add checkingfor attemps
        pinConnector?.acceptPin(call, result)
    }
    
    func denyPinRegistrationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        pinConnector?.denyPin(call, result)
    }
    
    func acceptPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        pinAuthenticationRequest?.acceptPin(call, result)
    }
    
    func denyPinAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        pinAuthenticationRequest?.denyPin(call, result)
    }
    
    func changePin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        changePinConnector?.changePin(call, result)
    }
    
    func validatePinWithPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        pinValidationConnector?.validatePinWithPolicy(call, result)
    }
    
    func acceptFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        biometricRequest?.acceptBiometric(call, result)
    }
    
    func denyFingerprintAuthenticationRequest(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        biometricRequest?.denyBiometric(call, result)
    }
    
    func fingerprintFallbackToPin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        biometricRequest?.fallbackToPin(call, result)
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
