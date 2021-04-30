//
//  BiometricChallange.swift
//  onegini
//
//  Created by Patryk Gałach on 24/04/2021.
//

import Foundation

import OneginiSDKiOS

protocol BiometricChallengeProtocol {
    func respond(withPrompt: String)
    func respondWithPinFallback()
    func respondWithDefaultPrompt()
    func cancel()
}

class BiometricChallenge: BiometricChallengeProtocol {
    var challenge: ONGBiometricChallenge
    
    init(challenge: ONGBiometricChallenge) {
        self.challenge = challenge
    }
    
    func respond(withPrompt: String) {
        challenge.sender.respond(withPrompt: withPrompt, challenge: challenge)
    }
    
    func respondWithPinFallback() {
        challenge.sender.respondWithPinFallback(for: challenge)
    }
    
    func respondWithDefaultPrompt() {
        challenge.sender.respondWithDefaultPrompt(for: challenge)
    }
    
    func cancel() {
        challenge.sender.cancel(challenge)
    }
}
