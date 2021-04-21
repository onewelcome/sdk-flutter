//
//  ChangePinWrapper.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import OneginiSDKiOS

// MARK: Wrapper Protocol
protocol ChangePinWrapperProtocol {
    func changePin()
    
    var providePin: ((ProvidePinChallengeProtocol) -> Void)? { get set }
    var createPin: ((CreatePinChallengeProtocol) -> Void)? { get set }
    var changePinSuccess: ((ONGUserProfile) -> Void)? { get set }
    var changePinFailed: ((ONGUserProfile, Error) -> Void)? { get set }
}

// MARK: Wrapper
class ChangePinWrapper: NSObject, ChangePinWrapperProtocol {
    
    // callbacks
    var providePin: ((ProvidePinChallengeProtocol) -> Void)?
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    var changePinSuccess: ((ONGUserProfile) -> Void)?
    var changePinFailed: ((ONGUserProfile, Error) -> Void)?
    
    // methods
    func changePin() {
        ONGUserClient.sharedInstance().changePin(self)
    }
}

extension ChangePinWrapper: ONGChangePinDelegate {
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        
        // make a factory for challenges?
        providePin?(ProvidePinChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        
        // make a factory for challenges?
        createPin?(CreatePinChallenge.init(challenge: challenge))
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToChangePinForUser userProfile: ONGUserProfile, error: Error) {
        
        changePinFailed?(userProfile, error)
    }

    func userClient(_ userClient: ONGUserClient, didChangePinForUser userProfile: ONGUserProfile) {
        
        changePinSuccess?(userProfile)
    }
}
