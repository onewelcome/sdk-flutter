import XCTest
@testable import onegini
import OneginiSDKiOS

class RegistrationHandler_ProcessRedirectURLTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testProcessRedirectionWithoutChallenge() throws {
        let dummyUrl = URL(string: "https://token-mobile.test.onegini.com/")
        XCTAssertNoThrow(handler?.processRedirectURL(url: dummyUrl!))
    }
    
    func testProcessRedirectionWithChallenge() throws {
        let dummyUrl = URL(string: "https://token-mobile.test.onegini.com/")
        handler?.browserRegistrationChallenge = ONGBrowserRegistrationChallenge()
        XCTAssertNoThrow(handler?.processRedirectURL(url: dummyUrl!))
    }
}
