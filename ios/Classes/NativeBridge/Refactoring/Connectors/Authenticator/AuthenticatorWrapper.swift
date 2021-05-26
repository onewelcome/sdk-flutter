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
    
    var registrationCompletion: AuthenticatorCallbackSuccess? { get set}
}

class AuthenticatorWrapper: NSObject, AuthenticatorWrapperProtocol {
    //MARK: Properties
    var registrationCompletion: AuthenticatorCallbackSuccess?
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
}

//MARK:- ONGAuthenticatorRegistrationDelegate
extension AuthenticatorWrapper: ONGAuthenticatorRegistrationDelegate {
    private func isAuthenticationAttemptIssue(previousFailureCount: Int, maxFailureCount: Int, error: Error?) -> Bool {
        guard let error = error,
           error.code == ONGAuthenticationError.invalidPin.rawValue,
           previousFailureCount < maxFailureCount else {
            return false
        }
        
        return true
    }
    
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        Logger.log("[AUTH] userClient didReceive ONGPinChallenge", sender: self)
        
        pinChallenge = challenge
        let pinError = FlutterError.fromPinChallenge(challenge)
        
        if isAuthenticationAttemptIssue(previousFailureCount: Int(challenge.previousFailureCount),
                                        maxFailureCount: Int(challenge.maxFailureCount),
                                        error: pinError)
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

