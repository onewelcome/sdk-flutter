import Foundation
import OneginiSDKiOS
import OneginiCrypto

//MARK: -
protocol BridgeToAuthenticatorsHandlerProtocol: AnyObject {
    func registerAuthenticator(_ userProfile: ONGUserProfile,_ authenticator: ONGAuthenticator, _ completion: @escaping (Bool, SdkError?) -> Void)
    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Bool, SdkError?) -> Void)
    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Bool, SdkError?) -> Void)
    func getAuthenticatorsListForUserProfile(_ userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func isAuthenticatorRegistered(_ authenticatorType: ONGAuthenticatorType, _ userProfile: ONGUserProfile) -> Bool
}

//MARK: -
class AuthenticatorsHandler: NSObject, PinHandlerToReceiverProtocol {
    var pinChallenge: ONGPinChallenge?
    var customAuthChallenge: ONGCustomAuthFinishRegistrationChallenge?
    var registrationCompletion: ((Bool, SdkError?) -> Void)?
    var deregistrationCompletion: ((Bool, SdkError?) -> Void)?
    
    func handlePin(pin: String?) {
        guard let customAuthChallenge = self.customAuthChallenge else {
            guard let pinChallenge = self.pinChallenge else { return }

            if let _pin = pin {
                pinChallenge.sender.respond(withPin: _pin, challenge: pinChallenge)

            } else {
                pinChallenge.sender.cancel(pinChallenge)
            }

            return
        }

        if let _pin = pin {
            customAuthChallenge.sender.respond(withData: _pin, challenge: customAuthChallenge)

        } else {
            customAuthChallenge.sender.cancel(customAuthChallenge, underlyingError: nil)
        }
    }

    fileprivate func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge) -> SdkError? {
        if let error = challenge.error {
            return ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            return nil
        }
    }
    
    fileprivate func sortAuthenticatorsList(_ authenticators: Array<ONGAuthenticator>) -> Array<ONGAuthenticator> {
        return authenticators.sorted {
            if $0.type.rawValue == $1.type.rawValue {
                return $0.name < $1.name
            } else {
                return $0.type.rawValue < $1.type.rawValue
            }
        }
    }
    
    private func sendConnectorNotification(_ event: MobileAuthNotification, _ requestMessage: String?, _ error: SdkError?) {
        BridgeConnector.shared?.toMobileAuthConnector.sendNotification(event: event, requestMessage: requestMessage, error: error)
    }
}

//MARK: - BridgeToAuthenticatorsHandlerProtocol
extension AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
    func registerAuthenticator(_ userProfile: ONGUserProfile, _ authenticator: ONGAuthenticator,_ completion: @escaping (Bool, SdkError?) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticator.identifier}) else {
            completion(false, SdkError(errorDescription: "This authenticator is not available."))
            return;
        }
        
        if(authenticator.isRegistered == true) {
            completion(false, SdkError(errorDescription: "This authenticator is already registered."))
            return;
        }
        
        registrationCompletion = completion;
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }

    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Bool, SdkError?) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(false, SdkError(errorDescription: "This authenticator is not available."))
            return;
        }
        
        if(authenticator.isRegistered != true) {
            completion(false, SdkError(errorDescription: "This authenticator is not registered."))
            return;
        }
        
        deregistrationCompletion = completion;
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }

    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Bool, SdkError?) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(false, SdkError(errorDescription: "This authenticator is not available."))
            return;
        }
        
        if(authenticator.isRegistered != true) {
            completion(false, SdkError(errorDescription: "This authenticator is not registered."))
            return;
        }
        
        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
        completion(true, nil)
    }
    
    func getAuthenticatorsListForUserProfile(_ userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        let authenticatros = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile)
        return sortAuthenticatorsList(Array(authenticatros))
    }
    
    func isAuthenticatorRegistered(_ authenticatorType: ONGAuthenticatorType, _ userProfile: ONGUserProfile) -> Bool {
        return ONGUserClient.sharedInstance().registeredAuthenticators(forUser: userProfile).first(where: {$0.type.rawValue == authenticatorType.rawValue }) != nil;
    }
}

//MARK: - ONGAuthenticatorRegistrationDelegate
extension AuthenticatorsHandler: ONGAuthenticatorRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        print("[AUTH] userClient didReceive ONGPinChallenge")
        
        pinChallenge = challenge
        let pinError = mapErrorFromPinChallenge(challenge)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        print("[AUTH] userClient didReceive ONGCustomAuthFinishRegistrationChallenge")
        // Will need this in the future
        registrationCompletion!(true, nil)
        
        customAuthChallenge = challenge

        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.create, nil, receiver: self)
    }

    func userClient(_: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        print("[AUTH] userClient didFailToRegister ONGAuthenticator")
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registrationCompletion!(false, SdkError(errorDescription: "Authenticator registration cancelled."))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registrationCompletion!(false, mappedError)
        }
    }

    func userClient(_: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        print("[AUTH] userClient didRegister ONGAuthenticator")
        registrationCompletion?(true, nil)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
    }
}

//MARK: - ONGAuthenticatorDeregistrationDelegate
extension AuthenticatorsHandler: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        print("[AUTH] userClient didDeregister ONGAuthenticator")
        deregistrationCompletion!(true, nil)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        print("[AUTH] userClient didReceive ONGCustomAuthDeregistrationChallenge")
        // will need this in the future
        
        deregistrationCompletion!(true, nil)
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        print("[AUTH] userClient didFailToDeregister ONGAuthenticator")
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            deregistrationCompletion?(false, SdkError(errorDescription: "Authenticator deregistration cancelled."))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            deregistrationCompletion?(false, mappedError)
        }
    }
}
