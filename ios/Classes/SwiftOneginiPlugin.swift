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


    func registerUser(identityProviderId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        
    }

    func handleRegisteredUserUrl(url: String?, signInType: Int32, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func getIdentityProviders(completion: @escaping (Result<[OWIdentityProvider], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getIdentityProviders())
    }

    func deregisterUser(profileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func getRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getRegisteredAuthenticators(profileId))
    }

    func getAllAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAllAuthenticators(profileId))
    }

    func getAuthenticatedUserProfile(completion: @escaping (Result<OWUserProfile, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAuthenticatedUserProfile())
    }

    func authenticateUser(profileId: String, registeredAuthenticatorId: String?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateUser(profileId: profileId, authenticatorId: registeredAuthenticatorId) { result in
            completion(result.mapError{$0})
        }
    }

    func getNotRegisteredAuthenticators(profileId: String, completion: @escaping (Result<[OWAuthenticator], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getNotRegisteredAuthenticators(profileId))
    }

    func changePin(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func setPreferredAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func deregisterAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func registerAuthenticator(authenticatorId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func mobileAuthWithOtp(data: String, completion: @escaping (Result<String?, Error>) -> Void) {
        
    }

    func getAppToWebSingleSignOn(url: String, completion: @escaping (Result<OWAppToWebSingleSignOn, Error>) -> Void) {
        
    }

    func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAccessToken())
    }

    func getRedirectUrl(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getRedirectUrl())
    }

    func getUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getUserProfiles())
    }

    func validatePinWithPolicy(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.validatePinWithPolicy(pin) { result in
            completion(result)
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
//        case Constants.Routes.registerUser: registerUser(call, result)
        case Constants.Routes.handleRegisteredUserUrl: handleRegisteredProcessUrl(call, result)
            
        case Constants.Routes.cancelBrowserRegistration: cancelBrowserRegistration(call, result)
        case Constants.Routes.setPreferredAuthenticator:
            setPreferredAuthenticator(call, result)
            
        case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)
            
            // custom registration
        case Constants.Routes.submitCustomRegistrationAction: submitCustomRegistrationAction(call, result)
        case Constants.Routes.cancelCustomRegistrationAction: cancelCustomRegistrationAction(call, result)
            
        case Constants.Routes.deregisterUser: deregisterUser(call, result)
            
            // auth
        case Constants.Routes.registerAuthenticator: registerAuthenticator(call, result)
        case Constants.Routes.authenticateUserImplicitly: authenticateUserImplicitly(call, result)
        case Constants.Routes.authenticateDevice: authenticateDevice(call, result)
            
        case Constants.Routes.deregisterAuthenticator:
            deregisterAuthenticator(call, result)
            
        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)
            
        case Constants.Routes.logout: logout(call, result)
            
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
            
            // other
        case Constants.Routes.changePin: changePin(call, result)
        case Constants.Routes.getAppToWebSingleSignOn: getAppToWebSingleSignOn(call, result)
            
        default: do {
            Logger.log("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
