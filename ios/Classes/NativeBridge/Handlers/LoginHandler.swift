import OneginiSDKiOS
import OneginiCrypto
import Flutter

//MARK: -
protocol BridgeToLoginHandlerProtocol: LoginHandlerToPinHanlderProtocol {
    func authenticateUser(_ profile: ONGUserProfile, authenticator: ONGAuthenticator?, completion: @escaping (ONGUserProfile?, SdkError?) -> Void)
}

protocol LoginHandlerToPinHanlderProtocol: class {
    var pinHandler: PinConnectorToPinHandler? { get set }
}

//MARK: -
class LoginHandler: NSObject, PinHandlerToReceiverProtocol {
    var pinChallenge: ONGPinChallenge?
    var customChallange: ONGCustomAuthFinishAuthenticationChallenge?
    var loginCompletion: ((ONGUserProfile?, SdkError?) -> Void)?

    unowned var pinHandler: PinConnectorToPinHandler?
    
    func handlePin(pin: String?) {
        if let _pin = pin {
            if let _cc = customChallange {
                _cc.sender.respond(withData: _pin, challenge: _cc)
            }
            if let _pc = pinChallenge {
                _pc.sender.respond(withPin: _pin, challenge: _pc)
            }
        } else {
            if let _cc = customChallange {
                _cc.sender.cancel(_cc, underlyingError: nil)
            }
            if let _pc = pinChallenge {
                _pc.sender.cancel(_pc)
            }
        }
    }
    
    fileprivate func mapErrorFromCustomAuthChallenge(_ challenge: ONGCustomAuthFinishAuthenticationChallenge) -> SdkError? {
        if let error = challenge.error, error.code != ONGAuthenticationError.customAuthenticatorFailure.rawValue {
            return ErrorMapper().mapError(error)
        } else {
            return nil
        }
    }
}

//MARK: -
extension LoginHandler : BridgeToLoginHandlerProtocol {
    func authenticateUser(_ profile: ONGUserProfile, authenticator: ONGAuthenticator?, completion: @escaping (ONGUserProfile?, SdkError?) -> Void) {
        loginCompletion = completion
        ONGUserClient.sharedInstance().authenticateUser(profile, authenticator: authenticator, delegate: self)
    }
}

//MARK: -
extension LoginHandler: ONGAuthenticationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        pinChallenge = challenge
        let pinError = ErrorMapper().mapErrorFromPinChallenge(challenge)

        if let error = pinError, error.code == ONGAuthenticationError.invalidPin.rawValue    , challenge.previousFailureCount < challenge.maxFailureCount { // 9009
            pinHandler?.handleFlowUpdate(PinFlow.nextAuthenticationAttempt, error, receiver: self)
            return
        }

        pinHandler?.handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)

        guard let _ = pinError else { return }
        guard challenge.maxFailureCount == challenge.previousFailureCount else {
            return
        }

        pinHandler?.closeFlow()
        pinHandler?.onCancel()

        loginCompletion?(nil, pinError)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge) {
        // TODO: Will need to check it in the future
        
        customChallange = challenge
        
        let customError = mapErrorFromCustomAuthChallenge(challenge)
        pinHandler?.handleFlowUpdate(PinFlow.authentication, customError, receiver: self)
        
        guard let _ = customError else { return }
        
        pinHandler?.closeFlow()
        pinHandler?.onCancel()
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, info customAuthInfo: ONGCustomInfo?) {
        
        pinChallenge = nil
        customChallange = nil
        
        loginCompletion?(userProfile, nil)
        pinHandler?.closeFlow()
    }

    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, authenticator: ONGAuthenticator, error: Error) {
        
        pinChallenge = nil
        customChallange = nil
        pinHandler?.closeFlow()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            loginCompletion?(nil, SdkError.init(customType: .loginCanceled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            loginCompletion?(nil, mappedError)
        }
    }
}
