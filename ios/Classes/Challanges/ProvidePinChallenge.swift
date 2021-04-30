//
//  ProvidePinChallenge.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import OneginiSDKiOS

protocol ProvidePinChallengeProtocol {
    func respond(withPin: String)
    func cancel()
}

class ProvidePinChallenge: ProvidePinChallengeProtocol {
    
    var challenge: ONGPinChallenge
    
    init(challenge: ONGPinChallenge) {
        self.challenge = challenge
    }
    
    func respond(withPin pin: String) {
        challenge.sender.respond(withPin: pin, challenge: challenge)
    }
    
    func cancel() {
        challenge.sender.cancel(challenge)
    }
}
