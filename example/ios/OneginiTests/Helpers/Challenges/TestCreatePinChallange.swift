//
//  TestRegistrationCreatePinChallange.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import OneginiSDKiOS
@testable import onegini

protocol TestPinListenerProtocol {
    func acceptPin(pin: String)
    func denyPin()
}

class TestCreatePinChallange: CreatePinChallengeProtocol {
    
    var receiver: TestPinListenerProtocol
    
    init(receiver: TestPinListenerProtocol) {
        self.receiver = receiver
    }
    
    func respond(withPin: String) {
        receiver.acceptPin(pin: withPin)
    }
    
    func cancel() {
        receiver.denyPin()
    }
}
