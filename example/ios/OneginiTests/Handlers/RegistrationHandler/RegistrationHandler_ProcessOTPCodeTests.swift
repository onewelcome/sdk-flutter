import XCTest
@testable import onegini

class RegistrationHandler_ProcessOTPCodeTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testProcessOTPCode() throws {
        let dummyCode = "dummycode"
        XCTAssertNoThrow(handler?.processOTPCode(code: dummyCode))
    }
    
    func testProcessOTPCodeWithNil() throws {
        XCTAssertNoThrow(handler?.processOTPCode(code: nil))
    }
}
