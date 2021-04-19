//
//  RegistrationWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 17/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol RegistrationWrapperProtocol {
    func register(providerId: String?, scopes: Array<String>?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void)
    func createPin(pin: String)
    func isUserRegistered(userId: String) -> Bool
    func getUserProfiles() -> Array<ONGUserProfile>
    func cancelFlow()
    func respondToRegistrationRequest(url: URL)
    
    var notificationReceiver: RegistrationNotificationReceiverProtocol? { get set }
}

// MARK: Notification Receiver Protocol
protocol RegistrationNotificationReceiverProtocol: class {
    func sendNotification(event: RegistrationNotification, eventData: Any?, error: SdkError?)
}

//MARK: Registration notification actions
enum RegistrationNotification : String {
    case initRegistration = "initRegistration"
    case finishRegistration = "finishRegistration"
    case createPin = "createPin"
    case handleUrl = "handleUrl"
    case eventError = "eventError"
}

// MARK: Wrapper
class RegistrationWrapper: NSObject, RegistrationWrapperProtocol {
    
    // challenges
    var browserRegistrationChallenge: ONGBrowserRegistrationChallenge?
    var createPinChallenge: ONGCreatePinChallenge?
    
    // callbacks
    var registrationCompletion: ((Bool, ONGUserProfile?, SdkError?) -> Void)?
    
    // notifications
    unowned var notificationReceiver: RegistrationNotificationReceiverProtocol?
    
    // MARK: methods
    func register(providerId: String?, scopes: Array<String>?, completion: @escaping (Bool, ONGUserProfile?, SdkError?) -> Void) {
        
        let identityProviders = Array(ONGUserClient.sharedInstance().identityProviders())
        
        var identityProvider = identityProviders.first(where: { $0.identifier == providerId})
        if let providerId = providerId, identityProvider == nil {
            identityProvider = ONGIdentityProvider()
            identityProvider?.name = providerId
            identityProvider?.identifier = providerId
        }
        
        ONGUserClient.sharedInstance().registerUser(with: identityProvider, scopes: scopes, delegate: self)
    }
    
    func createPin(pin: String) {
        if let createPinChallenge = createPinChallenge {
            createPinChallenge.sender.respond(withCreatedPin: pin, challenge: createPinChallenge)
        } else {
            notificationReceiver?.sendNotification(event: .eventError, eventData: nil, error: SdkError.init(customType: .createPinNotInProgress))
        }
    }
    
    func isUserRegistered(userId: String) -> Bool {
        let userProfiles = getUserProfiles()
        let isRegistered = userProfiles.first(where: { $0.profileId == userId}) != nil
        return isRegistered
    }
    
    func getUserProfiles() -> Array<ONGUserProfile> {
        let userProfiles = Array(ONGUserClient.sharedInstance().userProfiles())
        return userProfiles
    }
    
    func cancelFlow() {
        if let browserChallenge = browserRegistrationChallenge {
            browserChallenge.sender.cancel(browserChallenge)
        }
        
        if let createPinChallenge = createPinChallenge {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }
    
    func respondToRegistrationRequest(url: URL) {
        if let browserChallenge = browserRegistrationChallenge {
            browserChallenge.sender.respond(with: url, challenge: browserChallenge)
        } else {
#if DEBUG
            print("OneginiPlugin - tried to reply to registration challenge, bot no registration challenge is active")
#endif
        }
    }
}

extension RegistrationWrapper: ONGRegistrationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        
        createPinChallenge = challenge
        
        var pinError: SdkError?
        if let error = challenge.error {
            pinError = SdkError.init(errorDescription: error.localizedDescription, code: error.code)
            notificationReceiver?.sendNotification(event: .eventError, eventData: nil, error: pinError)
        } else {
            notificationReceiver?.sendNotification(event: .createPin, eventData: nil, error: nil)
        }
    }
    
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        
        browserRegistrationChallenge = challenge
        
        var browserError: SdkError?
        if let error = challenge.error {
            browserError = SdkError.init(errorDescription: error.localizedDescription, code: error.code)
            notificationReceiver?.sendNotification(event: .eventError, eventData: nil, error: browserError)
        } else {
            notificationReceiver?.sendNotification(event: .handleUrl, eventData: challenge.url, error: nil)
        }
    }
    
    func userClient(_: ONGUserClient, didRegisterUser userProfile: ONGUserProfile, info _: ONGCustomInfo?) {
        
        createPinChallenge = nil
        browserRegistrationChallenge = nil
        
        registrationCompletion?(true, userProfile, nil)
    }
    
    func userClient(_: ONGUserClient, didFailToRegisterWithError error: Error) {
        
        registrationCompletion?(false, nil, SdkError(title: error.domain, errorDescription: error.localizedDescription, recoverySuggestion: "", code: error.code))
    }
}
