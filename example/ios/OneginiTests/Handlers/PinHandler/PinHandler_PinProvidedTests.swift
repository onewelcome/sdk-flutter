import XCTest
@testable import onegini

class PinHandler_PinProvidedTests: XCTestCase, PinHandlerToReceiverProtocol {
    var handler: PinHandler?
    var pinHanlderCallback: (_ pin: String?) -> () = { _ in }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = PinHandler()
        handler!.pinReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        pinHanlderCallback = { _ in }
        try super.tearDownWithError()
    }
    
    func handlePin(pin: String?) {
        pinHanlderCallback(pin)
    }

    func testProcessPinWithLoginMode() throws {
        let expectation = self.expectation(description: "testProcessPinWithLoginMode")
        handler!.mode = PINEntryMode.login
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.onPinProvided(pin: testPin)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinWithRegisterMode() throws {
        let expectation = self.expectation(description: "testProcessPinWithRegisterMode")
        handler!.mode = PINEntryMode.registration
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.onPinProvided(pin: testPin)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinWithoutMode() throws {
        let expectation = self.expectation(description: "testProcessPinWithoutMode")
        handler!.mode = nil
        
        let testPin = "12312"
        pinHanlderCallback =  {
            pin in
            XCTAssert(testPin == pin)
            expectation.fulfill()
        }
        
        handler!.onPinProvided(pin: testPin)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testProcessPinWithoutNoPin() throws {
        let expectation = self.expectation(description: "testProcessPinWithoutNoPin")
        handler!.pinReceiver = self
        
        pinHanlderCallback =  {
            pin in
            XCTAssert(pin == "")
            expectation.fulfill()
        }
        
        handler!.onPinProvided(pin: "")
        waitForExpectations(timeout: 5, handler: nil)
    }
}
