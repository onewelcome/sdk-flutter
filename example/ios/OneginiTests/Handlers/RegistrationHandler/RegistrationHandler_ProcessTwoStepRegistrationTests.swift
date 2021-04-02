import XCTest
@testable import onegini

class RegistrationHandler_ProcessTwoStepRegistrationTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testProcessTwoStepRegistration() throws {
        let dummyData = "dummy data"
        XCTAssertNoThrow(handler?.processTwoStepRegistration(dummyData))
    }
}
