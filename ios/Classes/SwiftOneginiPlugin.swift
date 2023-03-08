import Flutter
import UIKit
import OneginiSDKiOS

extension FlutterError: Error {}

extension FlutterError {
    convenience init(_ error: OneWelcomeWrapperError) {
        let flutterError = SdkError(error).flutterError()
        self.init(code: flutterError.code, message: flutterError.message, details: flutterError.details)
    }
    convenience init(_ error: SdkError) {
        let flutterError = error.flutterError()
        self.init(code: flutterError.code, message: flutterError.message, details: flutterError.details)
    }
}

extension OWUserProfile {
    init(_ profile: UserProfile) {
        self.profileId = profile.profileId
    }
    init(_ profile: ONGUserProfile) {
        self.profileId = profile.profileId
    }
}

extension OWCustomInfo {
    init(_ info: CustomInfo) {
        status = Int32(info.status)
        data = info.data
    }
    init(_ info: ONGCustomInfo) {
        status = Int32(info.status)
        data = info.data
    }
}

extension OWAuthenticator {
    init(_ authenticator: ONGAuthenticator) {
        id = authenticator.identifier
        name = authenticator.name
        isPreferred = authenticator.isPreferred
        isRegistered = authenticator.isRegistered
        authenticatorType = Int32(authenticator.type.rawValue)
    }
}

extension OWIdentityProvider {
    init(_ identityProvider: ONGIdentityProvider) {
        id = identityProvider.identifier
        name = identityProvider.name
    }
}

func toOWCustomInfo(_ info: CustomInfo?) -> OWCustomInfo? {
    guard let info = info else { return nil }
    return OWCustomInfo(status: Int32(info.status), data: info.data)
}

func toOWCustomInfo(_ info: ONGCustomInfo?) -> OWCustomInfo? {
    guard let info = info else { return nil }
    return OWCustomInfo(status: Int32(info.status), data: info.data)
}


public class SwiftOneginiPlugin: NSObject, FlutterPlugin, UserClientApi {

    func submitCustomRegistrationAction(identityProviderId: String, data: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func cancelCustomRegistrationAction(identityProviderId: String, error: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func fingerprintFallbackToPin(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func fingerprintDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func fingerprintAcceptAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func otpDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func otpAcceptAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func pinDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func pinAcceptAuthenticationRequest(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func pinDenyRegistrationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func pinAcceptRegistrationRequest(pin: String, isCustomAuthenticator: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.submitPinAction(PinFlow.create.rawValue, action: PinAction.provide.rawValue, pin: pin, completion: completion)
        // FIXME: in the above function the completion is actually not yet used as that would create way to big of a refactor, so let's do it later in FP-49
        completion(.success(()))
    }

    func cancelBrowserRegistration(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func registerUser(identityProviderId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.registerUser(identityProviderId, scopes: scopes) { result in
            completion(result.mapError{$0})
        }
    }

    func handleRegisteredUserUrl(url: String, signInType: Int32, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.handleRegisteredProcessUrl(url, webSignInType: Int(signInType)).mapError({$0}))
    }

    func getIdentityProviders(completion: @escaping (Result<[OWIdentityProvider], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getIdentityProviders().mapError{$0})
    }

    func deregisterUser(profileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.deregisterUser(profileId: profileId) { result in
            completion(result.mapError{$0})
        }
    }

    func getRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getRegisteredAuthenticators(profileId).mapError{$0})
    }

    func getAllAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAllAuthenticators(profileId).mapError{$0})
    }

    func getAuthenticatedUserProfile(completion: @escaping (Result<OWUserProfile, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAuthenticatedUserProfile().mapError{$0})
    }

    func authenticateUser(profileId: String, registeredAuthenticatorId: String?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateUser(profileId: profileId, authenticatorId: registeredAuthenticatorId) { result in
            completion(result.mapError{$0})
        }
    }

    func getNotRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getNotRegisteredAuthenticators(profileId).mapError{$0})
    }

    func changePin(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.changePin() { result in
            completion(result.mapError{$0})
        }
    }

    func setPreferredAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.setPreferredAuthenticator(authenticatorId) { result in
            completion(result.mapError{$0})
        }
    }

    func deregisterAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.deregisterAuthenticator(authenticatorId) { result in
            completion(result.mapError{$0})
        }
    }

    func registerAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.registerAuthenticator(authenticatorId) { result in
            completion(result.mapError{$0})
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.logOut(){ result in
            completion(result.mapError{$0})
        }
    }

    func mobileAuthWithOtp(data: String, completion: @escaping (Result<String?, Error>) -> Void) {
        
    }

    func getAppToWebSingleSignOn(url: String, completion: @escaping (Result<OWAppToWebSingleSignOn, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.runSingleSignOn(url) { result in
            completion(result.mapError{$0})
        }
    }

    func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAccessToken().mapError{$0})
    }

    func getRedirectUrl(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getRedirectUrl().mapError{$0})
    }

    func getUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getUserProfiles().mapError{$0})
    }

    func validatePinWithPolicy(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.validatePinWithPolicy(pin) { result in
            completion(result.mapError{$0})
        }
    }

    func authenticateDevice(scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func authenticateUserImplicitly(profileId: String, scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    // FIXME: Remove when deleted from api
    func fetchUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void) {
        
    }

    static var flutterApi: NativeCallFlutterApi?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onegini", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "onegini_events",
                                               binaryMessenger: registrar.messenger())
        let instance = SwiftOneginiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)
        
        // Init Pigeon communication
        let messenger : FlutterBinaryMessenger = registrar.messenger()
        let api : UserClientApi & NSObjectProtocol = SwiftOneginiPlugin.init()
        UserClientApiSetup.setUp(binaryMessenger: messenger, api: api)
        
        flutterApi = NativeCallFlutterApi(binaryMessenger: registrar.messenger())
        
        // Example on call flutter function from native during start
        flutterApi?.testEventFunction(argument: "we initilized the function", completion: {_ in })
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Logger.log("call.method: \(call.method)", sender: self, logType: .log)
        let _arg = call.arguments as! [String: Any]?
        if ((_arg) != nil) {
            for key in _arg!.keys {
                Logger.log("key: " + key)
                let val = _arg?[key]
                Logger.log("value: " + String(describing: val))
            }
        }
        
        switch call.method {
            
            // base
        case Constants.Routes.startApp: startApp(call, result)
            
            // register
            
        case Constants.Routes.cancelBrowserRegistration: cancelBrowserRegistration(call, result)
            
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)
            
            // custom registration
        case Constants.Routes.submitCustomRegistrationAction: submitCustomRegistrationAction(call, result)
        case Constants.Routes.cancelCustomRegistrationAction: cancelCustomRegistrationAction(call, result)
            
            // auth
        case Constants.Routes.authenticateUserImplicitly: authenticateUserImplicitly(call, result)
        case Constants.Routes.authenticateDevice: authenticateDevice(call, result)

            
        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)
            
            // fingerprint
        case Constants.Routes.acceptFingerprintAuthenticationRequest: acceptFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.denyFingerprintAuthenticationRequest: denyFingerprintAuthenticationRequest(call, result)
        case Constants.Routes.fingerprintFallbackToPin: fingerprintFallbackToPin(call, result)
            
            // otp
        case Constants.Routes.handleMobileAuthWithOtp: handleMobileAuthWithOtp(call, result)
        case Constants.Routes.acceptOtpAuthenticationRequest: acceptOtpAuthenticationRequest(call, result)
        case Constants.Routes.denyOtpAuthenticationRequest: denyOtpAuthenticationRequest(call, result)
            
            // resources
        case Constants.Routes.getResourceAnonymous, Constants.Routes.getResource, Constants.Routes.getImplicitResource, Constants.Routes.unauthenticatedRequest:
            getResource(call, result)
            
        default: do {
            Logger.log("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
