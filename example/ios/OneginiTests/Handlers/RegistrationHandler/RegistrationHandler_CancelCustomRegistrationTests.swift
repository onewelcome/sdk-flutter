import XCTest
@testable import onegini

class RegistrationHandler_CancelCustomRegistrationTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testCancelCustomRegistration() throws {
        XCTAssertNoThrow(handler?.cancelCustomRegistration())
    }
}
