import XCTest
@testable import onegini

class PinHandler_CancelTests: XCTestCase, PinHandlerToReceiverProtocol {
    var handler: PinHandler?
    var pinHandlerCallback: ((_ pin: String?) -> ())?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = PinHandler()
        handler!.pinReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        pinHandlerCallback = nil
        try super.tearDownWithError()
    }
    
    func handlePin(pin: String?) {
        pinHandlerCallback?(pin)
    }

    func testOnCancel() throws {
        let expectation = self.expectation(description: "testOnCancel")
        handler!.mode = PINEntryMode.login
        
        pinHandlerCallback = {
            pin in
            print("[Test] OnCancel callback")
            XCTAssertNil(self.handler!.mode)
            XCTAssertNil(pin)
            expectation.fulfill()
        }
        
        XCTAssertNotNil(handler!.mode)
        handler!.onCancel()
        waitForExpectations(timeout: 5, handler: nil)
    }
}
