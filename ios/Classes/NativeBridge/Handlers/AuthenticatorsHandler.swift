import Foundation
import OneginiSDKiOS

//MARK: -
protocol BridgeToAuthenticatorsHandlerProtocol: AnyObject {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, Error>) -> Void)
    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Bool, SdkError?) -> Void)
    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Bool, SdkError?) -> Void)
    func getAuthenticatorsListForUserProfile(_ userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func isAuthenticatorRegistered(_ authenticatorType: ONGAuthenticatorType, _ userProfile: ONGUserProfile) -> Bool
    var notificationReceiver: AuthenticatorsNotificationReceiverProtocol? { get }
}

protocol AuthenticatorsNotificationReceiverProtocol: class {
    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?)
}

//MARK: -
class AuthenticatorsHandler: NSObject, PinHandlerToReceiverProtocol {
    var pinChallenge: ONGPinChallenge?
    var customAuthChallenge: ONGCustomAuthFinishRegistrationChallenge?
    var registrationCompletion: ((Result<Void, Error>) -> Void)?
    var deregistrationCompletion: ((Bool, SdkError?) -> Void)?

    unowned var notificationReceiver: AuthenticatorsNotificationReceiverProtocol?
    
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
        
        notificationReceiver?.sendNotification(event: event, requestMessage: requestMessage, error: error)
//        BridgeConnector.shared?.toMobileAuthConnector.sendNotification(event: event, requestMessage: requestMessage, error: error)
    }
}

//MARK: - BridgeToAuthenticatorsHandlerProtocol
extension AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let profile = ONGUserClient.sharedInstance().authenticatedUserProfile() else {
            completion(.failure(FlutterError(.noUserProfileIsAuthenticated)))
            return
        }

        // We don't have to check if the authenticator is already registered as the sdk will do that for us.
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: profile).first(where: { $0.identifier == authenticatorId }) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }
        registrationCompletion = completion;
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }

    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Bool, SdkError?) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(false, SdkError(.authenticatorNotFound))
            return
        }
        
        if(authenticator.isRegistered != true) {
            completion(false, SdkError(.authenticatorNotRegistered))
            return
        }
        
        deregistrationCompletion = completion;
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }

    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Bool, SdkError?) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(false, SdkError(.authenticatorNotFound))
            return
        }
        
        if(!authenticator.isRegistered) {
            completion(false, SdkError(.authenticatorNotRegistered))
            return
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
        Logger.log("[AUTH] userClient didReceive ONGPinChallenge", sender: self)
        
        pinChallenge = challenge
        let pinError = ErrorMapper().mapErrorFromPinChallenge(challenge)
        
        if let error = pinError, error.code == ONGAuthenticationError.invalidPin.rawValue, challenge.previousFailureCount < challenge.maxFailureCount { // 9009
            BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.nextAuthenticationAttempt, error, receiver: self)
            return
        }
        
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.authentication, pinError, receiver: self)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGCustomAuthFinishRegistrationChallenge", sender: self)
        // TODO: Will need to check it in the future
        
        registrationCompletion?(.success(()))
        customAuthChallenge = challenge
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.handleFlowUpdate(PinFlow.create, nil, receiver: self)
    }

    func userClient(_: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToRegister ONGAuthenticator", sender:self)
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registrationCompletion?(.failure(FlutterError(.authenticatorRegistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registrationCompletion?(.failure(FlutterError(mappedError)))
        }
    }

    func userClient(_: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        Logger.log("[AUTH] userClient didRegister ONGAuthenticator", sender: self)
        registrationCompletion?(.success(()))
        BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
    }
}

//MARK: - ONGAuthenticatorDeregistrationDelegate
extension AuthenticatorsHandler: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion!(true, nil)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGCustomAuthDeregistrationChallenge", sender: self)
        
        deregistrationCompletion!(true, nil)
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        //BridgeConnector.shared?.toPinHandlerConnector.pinHandler.closeFlow()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            deregistrationCompletion?(false, SdkError(.authenticatorDeregistrationCancelled))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            deregistrationCompletion?(false, mappedError)
        }
    }
}
