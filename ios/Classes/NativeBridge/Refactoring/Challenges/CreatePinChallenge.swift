//
//  CreatePinChallenge.swift
//  onegini
//
//  Created by Dream Store on 05.05.2021.
//

import Foundation
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

