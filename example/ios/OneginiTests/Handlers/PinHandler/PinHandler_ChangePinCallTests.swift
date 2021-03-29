import XCTest
import OneginiSDKiOS
@testable import onegini

class PinHandler_ChangePinCallTests: XCTestCase, PinHandlerToReceiverProtocol, NotificationReceiverProtocol {

    var handler: PinHandler?
    var pinHanlderCallback: (_ pin: String?) -> () = { _ in }
    var notificationCallback: (_ event: PinNotification, _ flow: PinFlow?, _ error: SdkError?) -> () = {_,_,_ in }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = PinHandler()
        handler!.pinReceiver = self
        handler!.notificationReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        pinHanlderCallback = { _ in }
        notificationCallback = {_,_,_ in }
        try super.tearDownWithError()
    }
    
    func handlePin(pin: String?) {
        pinHanlderCallback(pin)
    }
    
    func sendNotification(event: PinNotification, flow: PinFlow?, error: SdkError?) {
        notificationCallback(event, flow, error)
    }
    
    func testOnChangePinCalled() throws {
        
        // TODO: implement it - user first need to be logged in
        XCTAssertTrue(false, "Method not implemented")
        return
        
        let expectation = self.expectation(description: "testOnChangePinCalled")
        
        notificationCallback = {
            event, flow, error in
            print("[TEST] Notification: event: \(event) ; flow: \(flow.debugDescription)) ; error: \(error.debugDescription)")
            XCTAssert(event == PinNotification.open)
            XCTAssert(flow == PinFlow.create)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        pinHanlderCallback = {
            pin in
            print("[TEST] Pin: pin: \(String(describing: pin))")
            XCTAssertNotNil(pin)
            expectation.fulfill()
        }
        
        print("[TEST] Before change pin called")
        handler!.onChangePinCalled { (_, error) in
            print("[TEST] Change pin completed")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}
