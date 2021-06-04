import Foundation
import OneginiSDKiOS

typealias AuthenticatorCallbackSuccess = (Bool, Error?) -> Void

protocol AuthenticatorWrapperProtocol {
    func authenticatedUserProfile() -> ONGUserProfile?
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func registeredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func nonRegisteredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator>
    func setPreffered(authenticator: ONGAuthenticator)
    func register(authenticator: ONGAuthenticator, completion: @escaping AuthenticatorCallbackSuccess)
    func deregister(authenticator: ONGAuthenticator, completion: @escaping AuthenticatorCallbackSuccess)
    
    var registrationCompletion: AuthenticatorCallbackSuccess? { get set}
    var deregistrationCompletion: AuthenticatorCallbackSuccess? { get set}
}

class AuthenticatorWrapper: NSObject, AuthenticatorWrapperProtocol {
    //MARK: Properties
    var registrationCompletion: AuthenticatorCallbackSuccess?
    var deregistrationCompletion: AuthenticatorCallbackSuccess?
    var pinChallenge: ONGPinChallenge?
    var customAuthChallenge: ONGCustomAuthFinishRegistrationChallenge?
    
    //MARK: Methods
    func authenticatedUserProfile() -> ONGUserProfile? {
        return ONGUserClient.sharedInstance().authenticatedUserProfile()
    }
    
    func allAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().allAuthenticators(forUser: userProfile))
    }
    
    func registeredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().registeredAuthenticators(forUser: userProfile))
    }
    
    func nonRegisteredAuthenticators(for userProfile: ONGUserProfile) -> Array<ONGAuthenticator> {
        return Array(ONGUserClient.sharedInstance().nonRegisteredAuthenticators(forUser: userProfile))
    }
    
    func setPreffered(authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
    }
    
    func register(authenticator: ONGAuthenticator, completion: @escaping AuthenticatorCallbackSuccess) {
        self.registrationCompletion = completion
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }
    
    func deregister(authenticator: ONGAuthenticator, completion: @escaping AuthenticatorCallbackSuccess) {
        self.deregistrationCompletion = completion
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }
}

//MARK:- ONGAuthenticatorRegistrationDelegate
extension AuthenticatorWrapper: ONGAuthenticatorRegistrationDelegate {
    
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGPinChallenge", sender: self)
        
        pinChallenge = challenge
        //let pinError = FlutterError.fromPinChallenge(challenge)
        
        if challenge.containsAuthenticationAttemptIssue()
        {
            //TODO: nextAuthenticationAttempt
            return
        }
        
        //TODO: authentication
    }
    
    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGCustomAuthFinishRegistrationChallenge", sender: self)
        
        registrationCompletion?(true, nil)
        customAuthChallenge = challenge
        //TODO: create
    }

    func userClient(_: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToRegister ONGAuthenticator", sender:self)
        //TODO: closeFlow()
        registrationCompletion?(false, error)
    }

    func userClient(_: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        Logger.log("[AUTH] userClient didRegister ONGAuthenticator", sender: self)
        registrationCompletion?(true, nil)
        //TODO: closeFlow()
    }
}

//MARK:- ONGAuthenticatorDeregistrationDelegate
extension AuthenticatorWrapper: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        Logger.log("[AUTH] userClient didDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion?(true, nil)
        deregistrationCompletion = nil
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGCustomAuthDeregistrationChallenge", sender: self)
        //TODO: Need to discuss this behaviour
        challenge.sender.continue(with: challenge)
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        Logger.log("[AUTH] userClient didFailToDeregister ONGAuthenticator", sender: self)
        deregistrationCompletion?(false, error)
        deregistrationCompletion = nil
    }
}
