//
//  CreatePinChallenge.swift
//  Pods
//
//  Created by Patryk Gałach on 21/04/2021.
//

import OneginiSDKiOS

protocol CreatePinChallengeProtocol {
    func respond(withPin: String)
    func cancel()
}

class CreatePinChallenge: CreatePinChallengeProtocol {
    
    var challenge: ONGCreatePinChallenge
    
    init(challenge: ONGCreatePinChallenge) {
        self.challenge = challenge
    }
    
    func respond(withPin pin: String) {
        challenge.sender.respond(withCreatedPin: pin, challenge: challenge)
    }
    
    func cancel() {
        challenge.sender.cancel(challenge)
    }
}
