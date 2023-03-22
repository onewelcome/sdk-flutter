import Foundation
import OneginiSDKiOS

//MARK: -
protocol BridgeToAuthenticatorsHandlerProtocol: AnyObject {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void)
    func isAuthenticatorRegistered(_ authenticatorType: ONGAuthenticatorType, _ userProfile: ONGUserProfile) -> Bool
    var notificationReceiver: AuthenticatorsNotificationReceiverProtocol? { get }
}

protocol AuthenticatorsNotificationReceiverProtocol: class {
    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?)
}

//MARK: -
class AuthenticatorsHandler: NSObject {
    var pinChallenge: ONGPinChallenge?
    var customAuthChallenge: ONGCustomAuthFinishRegistrationChallenge?
    var registrationCompletion: ((Result<Void, FlutterError>) -> Void)?
    var deregistrationCompletion: ((Result<Void, FlutterError>) -> Void)?

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

    private func sendConnectorNotification(_ event: MobileAuthNotification, _ requestMessage: String?, _ error: SdkError?) {
        
        notificationReceiver?.sendNotification(event: event, requestMessage: requestMessage, error: error)
//        BridgeConnector.shared?.toMobileAuthConnector.sendNotification(event: event, requestMessage: requestMessage, error: error)
    }
}

//MARK: - BridgeToAuthenticatorsHandlerProtocol
extension AuthenticatorsHandler: BridgeToAuthenticatorsHandlerProtocol {
    func registerAuthenticator(_ authenticatorId: String, _ completion: @escaping (Result<Void, FlutterError>) -> Void) {
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

    func deregisterAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }
        
        if(authenticator.isRegistered != true) {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }
        
        deregistrationCompletion = completion;
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }

    func setPreferredAuthenticator(_ userProfile: ONGUserProfile, _ authenticatorId: String,_ completion: @escaping (Result<Void, FlutterError>) -> Void) {
        guard let authenticator = ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile).first(where: {$0.identifier == authenticatorId}) else {
            completion(.failure(FlutterError(.authenticatorNotFound)))
            return
        }
        
        // FIXME: Doesnt the sdk give us an error by itself?
        if(!authenticator.isRegistered) {
            completion(.failure(FlutterError(.authenticatorNotRegistered)))
            return
        }
        
        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
        completion(.success)
    }
    
    func isAuthenticatorRegistered(_ authenticatorType: ONGAuthenticatorType, _ userProfile: ONGUserProfile) -> Bool {
        return ONGUserClient.sharedInstance().registeredAuthenticators(forUser: userProfile).first(where: {$0.type.rawValue == authenticatorType.rawValue }) != nil;
    }
}

//MARK: - ONGAuthenticatorRegistrationDelegate
extension AuthenticatorsHandler: ONGAuthenticatorRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGPinChallenge", sender: self)
        BridgeConnector.shared?.toLoginHandler.handleDidReceiveChallenge(challenge)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        // We currently don't support custom authenticators
    }

    func userClient(_: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToRegister ONGAuthenticator", sender:self)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registrationCompletion?(.failure(FlutterError(.authenticatorRegistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registrationCompletion?(.failure(FlutterError(mappedError)))
        }
    }

    func userClient(_: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        Logger.log("[AUTH] userClient didRegister ONGAuthenticator", sender: self)
        BridgeConnector.shared?.toLoginHandler.handleDidAuthenticateUser()
        registrationCompletion?(.success)
    }
}

extension AuthenticatorsHandler: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion?(.success)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        // We currently don't support custom authenticators
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            deregistrationCompletion?(.failure(FlutterError(.authenticatorDeregistrationCancelled)))
        } else {
            let mappedError = ErrorMapper().mapError(error)
            deregistrationCompletion?(.failure(FlutterError(mappedError)))
        }
    }
}
