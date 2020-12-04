import OneginiSDKiOS
import OneginiCrypto

protocol BridgeToRegisterViewProtocol: AnyObject {
    func signUp(completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void)
    func handleRedirectURL(url: URL)
    func cancelRegistration()
    func logout(completion: @escaping ( SdkError?) -> Void)
    func deregister(completion: @escaping (SdkError?) -> Void)
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
    func logout(completion: @escaping ( SdkError?) -> Void) {
        logoutUserInteractor.logout(completion: completion)
    }
    
    func deregister(completion: @escaping (SdkError?) -> Void) {
        deregisterUserInteractor.disconnect(completion: completion)
    }
    
    func signUp(completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void) {
        signUpCompletion = completion
        registerUserViewToPresenterProtocol.signUp(nil)
    }
    
    func handleRedirectURL(url: URL) {
        registerUserInteractor.registerUserEntity.redirectURL = url
        registerUserViewToPresenterProtocol.handleRedirectURL()
    }
    
    func cancelRegistration() {
        registerUserInteractor.registerUserEntity.redirectURL = nil
        registerUserViewToPresenterProtocol.handleRedirectURL()
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