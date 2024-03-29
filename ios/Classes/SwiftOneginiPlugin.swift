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
        status = Int64(info.status)
        data = info.data
    }
    init(_ info: ONGCustomInfo) {
        status = Int64(info.status)
        data = info.data
    }
}

extension OWIdentityProvider {
    init(_ identityProvider: ONGIdentityProvider) {
        id = identityProvider.identifier
        name = identityProvider.name
    }
}

extension OWRequestResponse {
    init(_ response: ResourceResponse) {
        headers = toOWRequestHeaders(response.allHeaderFields)
        body = String(data: response.data ?? Data(), encoding: .utf8) ?? ""
        status = Int64(response.statusCode)
        ok = response.statusCode <= 299 && response.statusCode >= 200
    }
}

extension OWAuthenticatorType {
    func toOneginiType() -> AuthenticatorType {
        switch self {
        case .biometric:
            return AuthenticatorType.biometric
        case .pin:
            return AuthenticatorType.pin
        }
    }
}

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}

func toOWRequestHeaders(_ headers: [AnyHashable: Any]) -> [String: String] {
    return headers.filter { $0.key is String && $0.value is String } as? [String: String] ?? [:]
}

func toOWCustomInfo(_ info: CustomInfo?) -> OWCustomInfo? {
    guard let info = info else { return nil }
    return OWCustomInfo(status: Int64(info.status), data: info.data)
}

func toOWCustomInfo(_ info: ONGCustomInfo?) -> OWCustomInfo? {
    guard let info = info else { return nil }
    return OWCustomInfo(status: Int64(info.status), data: info.data)
}

public class SwiftOneginiPlugin: NSObject, FlutterPlugin, UserClientApi, ResourceMethodApi {

    func authenticateUser(profileId: String, authenticatorType: OWAuthenticatorType, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateUser(profileId: profileId, authenticatorType: authenticatorType.toOneginiType()) { result in
            completion(result.mapError { $0 })
        }
    }

    func authenticateUserPreferred(profileId: String, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateUser(profileId: profileId, authenticatorType: nil) { result in
            completion(result.mapError { $0 })
        }
    }

    func getBiometricAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.getBiometricAuthenticator(profileId: profileId) { result in
            completion(result.mapError { $0 })
        }
    }

    func getPreferredAuthenticator(profileId: String, completion: @escaping (Result<OWAuthenticator, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.getPreferredAuthenticator(profileId: profileId) { result in
            completion(result.mapError { $0 })
        }
    }

    func setPreferredAuthenticator(authenticatorType: OWAuthenticatorType, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.setPreferredAuthenticator(authenticatorType.toOneginiType()) { result in
            completion(result.mapError { $0 })
        }
    }

    func deregisterBiometricAuthenticator(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.deregisterBiometricAuthenticator { result in
            completion(result.mapError { $0 })
        }
    }

    func registerBiometricAuthenticator(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.registerBiometricAuthenticator { result in
            completion(result.mapError { $0 })
        }
    }

    func startApplication(securityControllerClassName: String?,
                          configModelClassName: String?,
                          customIdentityProviderConfigs: [OWCustomIdentityProvider]?,
                          connectionTimeout: Int64?,
                          readTimeout: Int64?,
                          additionalResourceUrls: [String]?,
                          completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.startOneginiModule(httpConnectionTimeout: connectionTimeout, additionalResourceUrls: additionalResourceUrls) { result in
            completion(result.mapError { $0 })
        }
    }

    func enrollMobileAuthentication(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.enrollMobileAuthentication { result in
            completion(result.mapError { $0 })
        }
    }

    func handleMobileAuthWithOtp(data: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.handleMobileAuthWithOtp(data) { result in
            completion(result.mapError { $0 })
        }
    }

    func requestResource(type: ResourceRequestType, details: OWRequestDetails, completion: @escaping (Result<OWRequestResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.requestResource(type, details) { result in
            completion(result.mapError { $0 })
        }
    }

    func submitCustomRegistrationAction(data: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationSuccess(data) { result in
            completion(result.mapError { $0 })
        }
    }

    func cancelCustomRegistrationAction(error: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.submitCustomRegistrationError(error) { result in
            completion(result.mapError { $0 })
        }
    }

    func fingerprintFallbackToPin(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.log("fingerprintFallbackToPin is Android only and should not be called on iOS")
        // FIXME: We should actually reject here with a specific error
        completion(.success)
    }

    func fingerprintDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.log("fingerprintDenyAuthenticationRequest is Android only and should not be called on iOS")
        // FIXME: We should actually reject here with a specific error
        completion(.success)
    }

    func fingerprintAcceptAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.log("fingerprintAcceptAuthenticationRequest is Android only and should not be called on iOS")
        // FIXME: We should actually reject here with a specific error
        completion(.success)
    }

    func otpDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.denyMobileAuthRequest { result in
            completion(result.mapError { $0 })
        }
    }

    func otpAcceptAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.acceptMobileAuthRequest { result in
            completion(result.mapError { $0 })
        }
    }

    func pinDenyAuthenticationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.pinDenyAuthenticationRequest { result in
            completion(result.mapError { $0 })
        }
    }

    func pinAcceptAuthenticationRequest(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.pinAcceptAuthenticationRequest(pin) { result in
            completion(result.mapError { $0 })
        }
    }

    func pinDenyRegistrationRequest(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.pinDenyRegistrationRequest { result in
            completion(result.mapError { $0 })
        }
    }

    func pinAcceptRegistrationRequest(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.pinAcceptRegistrationRequest(pin) { result in
            completion(result.mapError { $0 })
        }
    }

    func cancelBrowserRegistration(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.cancelBrowserRegistration { result in
            completion(result.mapError { $0 })
        }
    }

    func registerUser(identityProviderId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.registerUser(identityProviderId, scopes: scopes) { result in
            completion(result.mapError { $0 })
        }
    }

    func registerStatelessUser(identityProviderId: String?, scopes: [String]?, completion: @escaping (Result<OWRegistrationResponse, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.registerStatelessUser(identityProviderId, scopes: scopes) { result in
            completion(result.mapError { $0 })
        }
    }

    func handleRegisteredUserUrl(url: String, signInType: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.handleRegisteredProcessUrl(url, webSignInType: Int(signInType)).mapError({$0}))
    }

    func getIdentityProviders(completion: @escaping (Result<[OWIdentityProvider], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getIdentityProviders().mapError { $0 })
    }

    func deregisterUser(profileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.deregisterUser(profileId: profileId) { result in
            completion(result.mapError { $0 })
        }
    }

    func getAuthenticatedUserProfile(completion: @escaping (Result<OWUserProfile, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAuthenticatedUserProfile().mapError { $0 })
    }

    func changePin(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.changePin { result in
            completion(result.mapError { $0 })
        }
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.logOut { result in
            completion(result.mapError { $0 })
        }
    }

    func getAppToWebSingleSignOn(url: String, completion: @escaping (Result<OWAppToWebSingleSignOn, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.runSingleSignOn(url) { result in
            completion(result.mapError { $0 })
        }
    }

    func getAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getAccessToken().mapError { $0 })
    }

    func getRedirectUrl(completion: @escaping (Result<String, Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getRedirectUrl().mapError { $0 })
    }

    func getUserProfiles(completion: @escaping (Result<[OWUserProfile], Error>) -> Void) {
        completion(OneginiModuleSwift.sharedInstance.getUserProfiles().mapError { $0 })
    }

    func validatePinWithPolicy(pin: String, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.validatePinWithPolicy(pin) { result in
            completion(result.mapError { $0 })
        }
    }

    func authenticateDevice(scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateDevice(scopes) { result in
            completion(result.mapError { $0 })
        }
    }

    func authenticateUserImplicitly(profileId: String, scopes: [String]?, completion: @escaping (Result<Void, Error>) -> Void) {
        OneginiModuleSwift.sharedInstance.authenticateUserImplicitly(profileId, scopes) { result in
            completion(result.mapError { $0 })
        }
    }

    static var flutterApi: NativeCallFlutterApi?

    public static func register(with registrar: FlutterPluginRegistrar) {
        // Init Pigeon communication
        let messenger: FlutterBinaryMessenger = registrar.messenger()
        let api = SwiftOneginiPlugin()
        UserClientApiSetup.setUp(binaryMessenger: messenger, api: api)
        ResourceMethodApiSetup.setUp(binaryMessenger: messenger, api: api)
        flutterApi = NativeCallFlutterApi(binaryMessenger: registrar.messenger())
    }
}
