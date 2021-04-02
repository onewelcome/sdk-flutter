import XCTest
@testable import onegini

class RegistrationHandler_CancelTwoStepRegistrationTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testCancelTwoStepRegistration() throws {
        let errorMessage = "error message in test"
        XCTAssertNoThrow(handler?.cancelTwoStepRegistration(errorMessage))
    }
}
