import OneginiSDKiOS
import OneginiCrypto

protocol BridgeToRegisterViewProtocol: AnyObject {
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void)
    func handleRedirectURL(url: URL)
    func cancelRegistration()
    func logout(completion: @escaping (SdkError?) -> Void)
    func deregister(completion: @escaping (SdkError?) -> Void)
    func identityProviders() -> Array<ONGIdentityProvider>
    func handleOTPRegistration(code: String?)
}

protocol RegisterPresenterToViewProtocol: AnyObject {
    func onRegisterSuccess(_ authenticatedUserProfile: ONGUserProfile)
    func onRegisterFailed(_ error: SdkError)
    func onRegisterCancelled()
}

class RegistrationHandler {
  
    let registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol
    var registerUserPresenter: RegisterUserPresenterProtocol
    var registerUserInteractor = RegisterUserInteractor()
    var logoutUserInteractor = LogoutInteractor()
    var deregisterUserInteractor = DisconnectInteractor()
    var signUpCompletion: ((Bool, ONGUserProfile?, SdkError?) -> Void)?

    init() {
        self.registerUserPresenter = RegisterUserPresenter(registerUserInteractor: self.registerUserInteractor)
        self.registerUserInteractor.registerUserPresenter = self.registerUserPresenter
        self.registerUserViewToPresenterProtocol = self.registerUserPresenter
        self.registerUserPresenter.registerViewController = self
    }
}

extension RegistrationHandler : BridgeToRegisterViewProtocol {
    func identityProviders() -> Array<ONGIdentityProvider> {
        var list = self.registerUserInteractor.identityProviders()
        
        if let _providerId =  OneginiModuleSwift.sharedInstance.customIdentifier, list.filter({$0.identifier == _providerId}).count == 0  {
            
            let identityProvider = ONGIdentityProvider()
            identityProvider.name = _providerId
            identityProvider.identifier = _providerId
            
            list.append(identityProvider)
        }
        
        return list//self.registerUserInteractor.identityProviders()
    }
    
    func handleOTPRegistration(code: String?) {
        self.registerUserInteractor.handleOTPCode(code: code)
    }
    
    func logout(completion: @escaping ( SdkError?) -> Void) {
        logoutUserInteractor.logout(completion: completion)
    }
    
    func deregister(completion: @escaping (SdkError?) -> Void) {
        deregisterUserInteractor.disconnect(completion: completion)
    }
    
    func signUp(_ providerId: String?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void) {
        signUpCompletion = completion
        
        var identityProvider = identityProviders().first(where: { $0.identifier == providerId})
        if let _providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = _providerId
            identityProvider?.identifier = _providerId
        }
        
        registerUserViewToPresenterProtocol.signUp(identityProvider)
    }
    
    func handleRedirectURL(url: URL) {
        registerUserInteractor.registerUserEntity.redirectURL = url
        registerUserViewToPresenterProtocol.handleRedirectURL()
    }
    
    func cancelRegistration() {
        registerUserInteractor.registerUserEntity.cancelled = true
        self.registerUserInteractor.handleOTPCode(code: nil)
    }
}

extension RegistrationHandler : RegisterPresenterToViewProtocol {
    func onRegisterSuccess(_ authenticatedUserProfile: ONGUserProfile) {
        signUpCompletion!(true, authenticatedUserProfile, nil)
    }
  
    func onRegisterFailed(_ error: SdkError) {
        signUpCompletion!(false, nil, error)
    }
  
    func onRegisterCancelled() {
        signUpCompletion!(false, nil, SdkError(errorDescription: "Registration  cancelled."))
    }
}
