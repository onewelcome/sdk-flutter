//
//  TestRegistrationBrowserChallange.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 26/04/2021.
//

import OneginiSDKiOS
@testable import onegini

protocol TestBrowserListenerProtocol {
    func acceptBrowser(url: URL)
    func denyBrowser()
}

class TestBrowserChallange: BrowserRegistrationChallengeProtocol {
    
    var receiver: TestBrowserListenerProtocol
    
    init(receiver: TestBrowserListenerProtocol) {
        self.receiver = receiver
    }
    
    func respond(withUrl: URL) {
        receiver.acceptBrowser(url: withUrl)
    }
    
    func getUrl() -> URL {
        return URL.init(string: "https://test.onegini.com")!
    }
    
    func cancel() {
        receiver.denyBrowser()
    }
}
