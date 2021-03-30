import XCTest
@testable import onegini

class PinHandler_CloseFlowTests: XCTestCase, PinNotificationReceiverProtocol {

    var handler: PinHandler?
    var notificationCallback: ((_ event: PinNotification, _ flow: PinFlow?, _ error: SdkError?) -> ())?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = PinHandler()
        handler!.notificationReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        notificationCallback = nil
        try super.tearDownWithError()
    }
    
    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) {
        notificationCallback?(event, flow, error)
    }
    
    func testCloseFlowForLogin() throws {
        let expectation = self.expectation(description: "testCloseFlowForLogin")
        handler!.flow = PinFlow.authentication
        handler!.mode = PINEntryMode.login
        
        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.closeAuth)
            XCTAssertNil(flow)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        handler!.closeFlow()
        
        XCTAssertNil(handler!.flow)
        XCTAssertNil(handler!.mode)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCloseFlowForRegistration() throws {
        let expectation = self.expectation(description: "testCloseFlowForRegistration")
        handler!.flow = PinFlow.create
        handler!.mode = PINEntryMode.registration
        
        notificationCallback = {
            event, flow, error in
            XCTAssert(event == PinNotification.close)
            XCTAssertNil(flow)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        handler!.closeFlow()
        
        XCTAssertNil(handler!.flow)
        XCTAssertNil(handler!.mode)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
