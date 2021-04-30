//
//  BrowserRegistrationChallenge.swift
//  onegini
//
//  Created by Patryk Gałach on 21/04/2021.
//

import OneginiSDKiOS

protocol BrowserRegistrationChallengeProtocol {
    func respond(withUrl: URL)
    func getUrl() -> URL
    func cancel()
}

class BrowserRegistrationChallenge: BrowserRegistrationChallengeProtocol {
    
    var challenge: ONGBrowserRegistrationChallenge
    
    init(challenge: ONGBrowserRegistrationChallenge) {
        self.challenge = challenge
    }
    
    func respond(withUrl url: URL) {
        challenge.sender.respond(with: url, challenge: challenge)
    }
    
    func getUrl() -> URL {
        return challenge.url
    }
    
    func cancel() {
        challenge.sender.cancel(challenge)
    }
}
