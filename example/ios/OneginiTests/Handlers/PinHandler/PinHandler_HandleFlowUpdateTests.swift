import XCTest
@testable import onegini

class PinHandler_HandleFlowUpdateTests: XCTestCase, PinHandlerToReceiverProtocol, PinNotificationReceiverProtocol {

    var handler: PinHandler?
    var pinHandlerCallback: ((_ pin: String?) -> ())?
    var notificationCallback: ((_ event: PinNotification, _ flow: PinFlow?, _ error: SdkError?) -> ())?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = PinHandler()
        handler!.pinReceiver = self
        handler!.notificationReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        pinHandlerCallback = nil
        notificationCallback = nil
        try super.tearDownWithError()
    }
    
    func handlePin(pin: String?) {
        pinHandlerCallback?(pin)
    }
    
    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) {
        notificationCallback?(event, flow, error)
    }
    
    func testHandleFlowUpdateWithCreateFlow() throws {
        let expectation = self.expectation(description: "testHandleFlowUpdateWithCreateFlow")
        
        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.open)
            XCTAssert(flow == PinFlow.create)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        handler!.handleFlowUpdate(PinFlow.create, nil, receiver: self)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHandleFlowUpdateWithAuthFlow() throws {
        let expectation = self.expectation(description: "testHandleFlowUpdateWithAuthFlow")
        
        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.openAuth)
            XCTAssert(flow == PinFlow.authentication)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        handler!.handleFlowUpdate(PinFlow.authentication, nil, receiver: self)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHandleFlowUpdateWithChangeFlow() throws {
        let expectation = self.expectation(description: "testHandleFlowUpdateWithChangeFlow")
        
        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.open)
            XCTAssert(flow == PinFlow.change)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        handler!.handleFlowUpdate(PinFlow.change, nil, receiver: self)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testHandleFlowUpdateWithErrorFlow() throws {
        let expectation = self.expectation(description: "testHandleFlowUpdateWithErrorFlow")

        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.showError)
            XCTAssert(flow == PinFlow.authentication)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }

        handler!.handleFlowUpdate(PinFlow.authentication, SdkError(errorDescription: "Error test description"), receiver: self)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
