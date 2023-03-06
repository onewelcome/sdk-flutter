import Flutter
import UIKit
import OneginiSDKiOS

extension FlutterError: Error {}

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

func toOWCustomInfo(_ info: CustomInfo?) -> OWCustomInfo? {
    guard let info = info else { return nil }
    return OWCustomInfo(status: Int32(info.status), data: info.data)
}

public class SwiftOneginiPlugin: NSObject, FlutterPlugin, UserClientApi {
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
        case Constants.Routes.registerUser: registerUser(call, result)
        case Constants.Routes.handleRegisteredUserUrl: handleRegisteredProcessUrl(call, result)
            
        case Constants.Routes.getIdentityProviders: getIdentityProviders(call, result)
        case Constants.Routes.cancelBrowserRegistration: cancelBrowserRegistration(call, result)
        case Constants.Routes.setPreferredAuthenticator:
            setPreferredAuthenticator(call, result)
            
        case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)
        case Constants.Routes.getRedirectUrl: getRedirectUrl(call, result)
            
            // custom registration
        case Constants.Routes.submitCustomRegistrationAction: submitCustomRegistrationAction(call, result)
        case Constants.Routes.cancelCustomRegistrationAction: cancelCustomRegistrationAction(call, result)
            
        case Constants.Routes.deregisterUser: deregisterUser(call, result)
            
            // auth
        case Constants.Routes.registerAuthenticator: registerAuthenticator(call, result)
        case Constants.Routes.authenticateUser: authenticateUser(call, result)
        case Constants.Routes.authenticateUserImplicitly: authenticateUserImplicitly(call, result)
        case Constants.Routes.authenticateDevice: authenticateDevice(call, result)
            
        case Constants.Routes.getRegisteredAuthenticators: getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators: getAllNotRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllAuthenticators: getAllAuthenticators(call, result)
        case Constants.Routes.deregisterAuthenticator:
            deregisterAuthenticator(call, result)
            
        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)
            
        case Constants.Routes.logout: logout(call, result)
            
        case Constants.Routes.validatePinWithPolicy:
            validatePinWithPolicy(call, result)
//        case Constants.Routes.getAuthenticatedUserProfile: getAuthenticatedUserProfile(result)
        case Constants.Routes.getUserProfiles: getUserProfiles(result)
//        case Constants.Routes.getAccessToken: getAccessToken(result)
            
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
    
    // Example function for Flutter -> Native functions and how to return a response or error
    func fetchUserProfiles(completion: @escaping (Result<[PigeonUserProfile], Error>) -> Void) {
        //        let a = .success([PigeonUserProfile(profileId: "boopios", isDefault: true)])
        completion(.failure(SdkError(.userProfileDoesNotExist).flutterError()))
        
        //        completion(.success([PigeonUserProfile(profileId: "boopios", isDefault: true)]))
    }
}
