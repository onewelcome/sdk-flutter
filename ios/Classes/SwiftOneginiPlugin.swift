import Flutter
import UIKit

public class SwiftOneginiPlugin: NSObject, FlutterPlugin {
    
    var flutterConnector: FlutterConnectorProtocol?
    var startAppConnector: StartAppConnectorProtocol
    var registrationConnector: RegistrationConnectorProtocol
    var pinConnector: PinConnectorProtocol

    override init() {
//        flutterConnector = FlutterConnector()
        flutterConnector = OneginiModuleSwift.sharedInstance
        
        startAppConnector = StartAppConnector.init(startAppWrapper: StartAppWrapper())
        
        registrationConnector = NewRegistrationConnector.init(registrationWrapper: RegistrationWrapper())
        registrationConnector.flutterConnector = flutterConnector
        
        pinConnector = NewPinConnector.init(pinWrapper: PinWrapper())
        pinConnector.flutterConnector = flutterConnector
        
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "onegini", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "onegini_events",
                                                  binaryMessenger: registrar.messenger())
        let instance = SwiftOneginiPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(OneginiModuleSwift.sharedInstance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
#if DEBUG
        print("call.method: ", call.method)
        let _arg = call.arguments as! [String: Any]?
        if ((_arg) != nil) {
            for key in _arg!.keys {
                print("key: " + key)
                let val = _arg?[key]
                print("value: " + String(describing: val))
            }
        }
#endif
        
        switch call.method {
        
        // TODO: add new methods to constants
        // new start app
        case "new_startApp": startAppConnector.startApp(call, result)
        case "new_reset": startAppConnector.reset(call, result)
        
        // new register
        case "new_registerUser": registrationConnector.register(call, result)
        case "new_createPin": registrationConnector.createPin(call, result)
        case "new_getUserProfiles": registrationConnector.getUserProfiles(call, result)
        case "new_isUserRegistered": registrationConnector.isUserRegistered(call, result)
        case "new_cancelUserRegistration": registrationConnector.cancelFlow(call, result)
        case "new_respondToRegistrationRequest": registrationConnector.respondToRegistrationRequest(call, result)
            
        // new pin
        case "new_authorizePin": pinConnector.authorizePin(call, result)
        case "new_registerPin": pinConnector.registerPin(call, result)
        case "new_cancelPin": pinConnector.cancelPin(call, result)
        case "new_changePin": pinConnector.changePin(call, result)
        case "new_validatePinWithPolicy": pinConnector.validatePinWithPolicy(call, result)
            
            
        // base
        case Constants.Routes.startApp: startApp(call, result)
            
        // register
        case Constants.Routes.registerUser: registerUser(call, result)
        
        case Constants.Routes.getIdentityProviders: getIdentityProviders(call, result)
        case Constants.Routes.cancelRegistration: cancelRegistration(call, result)
        case Constants.Routes.setPreferredAuthenticator:
            setPreferredAuthenticator(call, result)
        
        case Constants.Routes.acceptPinRegistrationRequest: acceptPinRegistrationRequest(call, result)
        case Constants.Routes.denyPinRegistrationRequest: denyPinRegistrationRequest(call, result)
        
        case Constants.Routes.customTwoStepRegistrationReturnSuccess: customTwoStepRegistrationReturnSuccess(call, result)
        case Constants.Routes.customTwoStepRegistrationReturnError: customTwoStepRegistrationReturnError(call, result)
            
        case Constants.Routes.deregisterUser: deregisterUser(call, result)
            
        // auth
        case Constants.Routes.registerAuthenticator: registerAuthenticator(call, result)
        case Constants.Routes.authenticateUser: authenticateUser(call, result)
        
        case Constants.Routes.getRegisteredAuthenticators: getRegisteredAuthenticators(call, result)
        case Constants.Routes.getAllNotRegisteredAuthenticators: getAllNotRegisteredAuthenticators(call, result)
        case Constants.Routes.deregisterAuthenticator:
            deregisterAuthenticator(call, result)
        
        case Constants.Routes.acceptPinAuthenticationRequest: acceptPinAuthenticationRequest(call, result)
        case Constants.Routes.denyPinAuthenticationRequest: denyPinAuthenticationRequest(call, result)
        
        case Constants.Routes.logout: logout(call, result)
            
        case Constants.Routes.validatePinWithPolicy:
            validatePinWithPolicy(call, result)
        
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
        case Constants.Routes.userProfiles: fetchUserProfiles(result)
        
        default: do {
            print("Method wasn't handled: " + call.method)
            result(FlutterMethodNotImplemented)
        }
        }
    }
}
