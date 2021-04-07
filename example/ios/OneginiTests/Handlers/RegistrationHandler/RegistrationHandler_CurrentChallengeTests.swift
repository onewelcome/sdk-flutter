import XCTest
@testable import onegini
import OneginiSDKiOS

class RegistrationHandler_CurrentChallengeTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testCurrentChallengeAssigned() throws {
        handler?.customRegistrationChallenge = ONGCustomRegistrationChallenge()
        let challenge = handler?.currentChallenge()
        XCTAssertNotNil(challenge)
    }
    
    func testCurrentChallengeNotAssigned() throws {
        let challenge = handler?.currentChallenge()
        XCTAssertNil(challenge)
    }
}
