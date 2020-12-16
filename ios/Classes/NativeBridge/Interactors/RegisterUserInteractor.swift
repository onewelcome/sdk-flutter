import OneginiSDKiOS
import OneginiCrypto

protocol RegisterUserInteractorProtocol: AnyObject {
    func identityProviders() -> Array<ONGIdentityProvider>
    func startUserRegistration(identityProvider: ONGIdentityProvider?)
    func handleRedirectURL()
    func handleCreatedPin()
    func handleOTPCode(code: String?)
    func customIdentifier() -> String?
}

class RegisterUserInteractor: NSObject {
    weak var registerUserPresenter: RegisterUserInteractorToPresenterProtocol?
    var registerUserEntity = RegisterUserEntity()

    fileprivate func mapErrorFromChallenge(_ challenge: ONGCreatePinChallenge) {
        if let error = challenge.error {
            registerUserEntity.pinError = ErrorMapper().mapError(error)
        } else {
            registerUserEntity.pinError = nil
        }
    }
}

extension RegisterUserInteractor: RegisterUserInteractorProtocol {
    func customIdentifier() -> String? {
        return OneginiModuleSwift.sharedInstance.customIdentifier
    }
    
    func handleOTPCode(code: String?) {
        guard let customRegistrationChallenge = registerUserEntity.customRegistrationChallenge else { return }
        if registerUserEntity.cancelled {
            registerUserEntity.cancelled = false
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
        } else {
            customRegistrationChallenge.sender.respond(withData: code, challenge: customRegistrationChallenge)
        }
    }
    
    
    func identityProviders() -> Array<ONGIdentityProvider> {
        let identityProviders = ONGUserClient.sharedInstance().identityProviders()
        return Array(identityProviders)
    }

    func startUserRegistration(identityProvider: ONGIdentityProvider? = nil) {
        let list = identityProviders()
        list.forEach({ print($0.identifier) })
        
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: ["read"], delegate: self)
    }

    func handleRedirectURL() {
        guard let browserRegistrationChallenge = registerUserEntity.browserRegistrationChallenge else { return }
        if let url = registerUserEntity.redirectURL {
            browserRegistrationChallenge.sender.respond(with: url, challenge: browserRegistrationChallenge)
        } else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
        }
    }

    func handleCreatedPin() {
        guard let createPinChallenge = registerUserEntity.createPinChallenge else { return }
        if let pin = registerUserEntity.pin {
            createPinChallenge.sender.respond(withCreatedPin: pin, challenge: createPinChallenge)
        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }
    
    fileprivate func mapErrorMessageFromStatus(_ status: Int) {
        if status <= 2000 {
            registerUserEntity.errorMessage = nil
        } else if status == 4002 {
            registerUserEntity.errorMessage = "This code is not initialized on portal."
        } else {
            registerUserEntity.errorMessage = "Provided code is incorrect."
        }
    }
}

extension RegisterUserInteractor: ONGRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        registerUserEntity.browserRegistrationChallenge = challenge
        registerUserEntity.registrationUserURL = challenge.url
        registerUserPresenter?.presentBrowserUserRegistrationView(registerUserEntity: registerUserEntity)
    }

    func userClient(_: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        registerUserEntity.createPinChallenge = challenge
        registerUserEntity.pinLength = Int(challenge.pinLength)
        mapErrorFromChallenge(challenge)
        registerUserPresenter?.presentCreatePinView(registerUserEntity: registerUserEntity)
    }

    func userClient(_: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info _: ONGCustomInfo?) {
      registerUserPresenter?.registerUserActionSuccess(authenticatedUserProfile: userProfile)
    }

    func userClient(_: ONGUserClient, didFailToRegisterWithError error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registerUserPresenter?.registerUserActionCancelled()
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registerUserPresenter?.registerUserActionFailed(mappedError)
        }
    }
    
    func userClient(_: ONGUserClient, didReceiveCustomRegistrationInitChallenge challenge: ONGCustomRegistrationChallenge) {
        if challenge.identityProvider.identifier == customIdentifier() {
            challenge.sender.respond(withData: nil, challenge: challenge)
        }
    }

    func userClient(_: ONGUserClient, didReceiveCustomRegistrationFinish challenge: ONGCustomRegistrationChallenge) {
        if challenge.identityProvider.identifier == customIdentifier() {
            if let info = challenge.info {
                registerUserEntity.challengeCode = info.data
                mapErrorMessageFromStatus(info.status)
            }
            registerUserEntity.customRegistrationChallenge = challenge
            
            // *****
            registerUserPresenter?.presentTwoWayOTPRegistrationView(registerUserEntity: registerUserEntity)
        }
    }
}
