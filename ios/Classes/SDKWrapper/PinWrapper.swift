//
//  PinWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 20/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol PinWrapperProtocol {
    func changePin(completion: @escaping (Bool, SdkError?) -> Void)
    func validatePinWithPolicy(pin: String, completion: @escaping (Bool, SdkError?) -> Void)
    
    var notificationReceiver: NewPinNotificationReceiverProtocol? { get set }
}

// MARK: Notification Receiver Protocol
protocol NewPinNotificationReceiverProtocol: class {
    func sendNotification(event: NewPinNotification, eventData: Any?, error: SdkError?)
}

//MARK: Pin notification actions
enum NewPinNotification : String {
    case openPinAuthorization = "openPinAuthorization"
    case closePinAuthorization = "closePinAuthorization"
    case openPinCreation = "openPinCreation"
    case closePinCreation = "closePinCreation"
    case eventError = "eventError"
}

// MARK: Wrapper
class PinWrapper: NSObject, PinWrapperProtocol {
    
    // challenges
    var authorizePinChallenge: ONGPinChallenge?
    var createPinChallenge: ONGCreatePinChallenge?
    
    // callbacks
    var changePinCompletion: ((Bool, SdkError?) -> Void)?
    
    // notifications
    unowned var notificationReceiver: NewPinNotificationReceiverProtocol?
    
    
    func changePin(completion: @escaping (Bool, SdkError?) -> Void) {
        changePinCompletion = completion
        
        ONGUserClient.sharedInstance().changePin(self)
    }
    
    func validatePinWithPolicy(pin: String, completion: @escaping (Bool, SdkError?) -> Void) {
        ONGUserClient.sharedInstance().validatePin(withPolicy: pin) { (success, error) in
            
            var pinError: SdkError?
            if let error = error {
                pinError = SdkError.init(errorDescription: error.localizedDescription, code: error.code)
                completion(success, pinError)
            } else {
                completion(success, nil)
            }
        }
    }
}

extension PinWrapper: ONGChangePinDelegate {
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        authorizePinChallenge = challenge
        
        var pinError: SdkError?
        if let error = challenge.error {
            pinError = SdkError.init(errorDescription: error.localizedDescription, code: error.code)
            notificationReceiver?.sendNotification(event: .eventError, eventData: nil, error: pinError)
        } else {
            notificationReceiver?.sendNotification(event: .openPinAuthorization, eventData: nil, error: nil)
        }
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        authorizePinChallenge = nil
        createPinChallenge = challenge
        
        var pinError: SdkError?
        if let error = challenge.error {
            pinError = SdkError.init(errorDescription: error.localizedDescription, code: error.code)
            notificationReceiver?.sendNotification(event: .eventError, eventData: nil, error: pinError)
        } else {
            notificationReceiver?.sendNotification(event: .openPinCreation, eventData: nil, error: nil)
        }
    }
    
    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        authorizePinChallenge = nil
        createPinChallenge = nil
        
        changePinCompletion?(false, SdkError.init(errorDescription: error.localizedDescription, code: error.code))
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        authorizePinChallenge = nil
        createPinChallenge = nil
        
        changePinCompletion?(true, nil)
    }
}
