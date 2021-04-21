import XCTest
import OneginiSDKiOS
@testable import onegini

class PinHandler_ChangePinCallTests: XCTestCase, PinHandlerToReceiverProtocol, PinNotificationReceiverProtocol {

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
    
    func testOnChangePinCalled() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
//        // TODO: implement it - user first need to be logged in
//        XCTAssertTrue(false, "Method not implemented")
//        return
        
        expectation = self.expectation(description: "testOnChangePinCalled")
        
        notificationCallback = {
            event, flow, error in
            print("[TEST] Notification: event: \(event) ; flow: \(flow.debugDescription)) ; error: \(error.debugDescription)")
            XCTAssert(event == PinNotification.open)
            XCTAssert(flow == PinFlow.create)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        pinHandlerCallback = {
            pin in
            print("[TEST] Pin: pin: \(String(describing: pin))")
            XCTAssertNotNil(pin)
            expectation.fulfill()
        }
        
        print("[TEST] Before change pin called")
        handler!.onChangePinCalled { (success, error) in
            print("[TEST] Change pin completed: \(success) ; e:\(error?.errorDescription)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
