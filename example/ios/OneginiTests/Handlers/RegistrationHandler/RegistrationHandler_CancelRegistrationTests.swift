import XCTest
@testable import onegini
import OneginiSDKiOS

class RegistrationHandler_CancelRegistrationTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testCancelRegistrationWithoutChallenge() throws {
        XCTAssertNoThrow(handler?.cancelRegistration())
    }
    
    func testCancelRegistrationWithChallenge() throws {
        handler?.browserRegistrationChallenge = ONGBrowserRegistrationChallenge()
        XCTAssertNoThrow(handler?.cancelRegistration())
    }
}
