import OneginiSDKiOS
import OneginiCrypto
import Flutter

//MARK: -
protocol BridgeToLoginHandlerProtocol: AnyObject {
    func authenticateUser(_ profile: ONGUserProfile, authenticator: ONGAuthenticator?, completion: @escaping (ONGUserProfile?, SdkError?) -> Void)
}

//MARK: -
class LoginHandler: NSObject, PinHandlerToReceiverProtocol {
    var pinChallenge: ONGPinChallenge?
    var customChallange: ONGCustomAuthFinishAuthenticationChallenge?
    var loginCompletion: ((ONGUserProfile?, SdkError?) -> Void)?

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

    fileprivate func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge) -> SdkError? {
        if let error = challenge.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue {
            return ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            return nil
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
        let pinError = mapErrorFromPinChallenge(challenge)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)
        
        guard let _ = pinError else { return }
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
        
        loginCompletion?(nil, pinError)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge) {
        // TODO: Will need to check it in the future
        
        customChallange = challenge
        
        let customError = mapErrorFromCustomAuthChallenge(challenge)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.authentication, customError, receiver: self)
        
        guard let _ = customError else { return }
        
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        OneginiModuleSwift.sharedInstance.cancelPinAuth()
    }

    func userClient(_: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info _: ONGCustomInfo?) {
        
        pinChallenge = nil
        customChallange = nil
        
        loginCompletion?(userProfile, nil)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
    }

    func userClient(_: ONGUserClient, didFailToAuthenticateUser profile: ONGUserProfile, error: Error) {
        
        pinChallenge = nil
        customChallange = nil
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()

        if error.code == ONGGenericError.actionCancelled.rawValue {
            loginCompletion?(nil, SdkError.init(customType: .loginCanceled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            loginCompletion?(nil, mappedError)
        }
    }
}
