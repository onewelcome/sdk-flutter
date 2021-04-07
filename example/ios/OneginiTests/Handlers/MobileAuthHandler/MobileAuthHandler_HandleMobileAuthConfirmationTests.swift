import XCTest
@testable import onegini

class MobileAuthHandler_HandleMobileAuthConfirmationTests: XCTestCase, MobileAuthNotificationReceiverProtocol {
    
    var handler: MobileAuthHandler?
    var notificationCallback: ((_ event: MobileAuthNotification, _ requestMessage: String?, _ error: SdkError?) -> ())?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = MobileAuthHandler()
        handler!.notificationReceiver = self
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func sendNotification(event: MobileAuthNotification, requestMessage: String?, error: SdkError?) {
        print("[\(type(of: self))] sendNotification: event: \(event) ; message: \(requestMessage) ; error: \(error)")
        notificationCallback?(event, requestMessage, error)
    }
    
    func testHandleMobileAuthConfirmationWithNil() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleMobileAuthConfirmationWithNil")
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        handler?.handleMobileAuthConfirmation(cancelled: false)
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHandleMobileAuthConfirmationWithConfirmation() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleMobileAuthConfirmationWithConfirmation")
        handler?.authenticatorType = .confirmation
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        handler?.handleMobileAuthConfirmation(cancelled: false)
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHandleMobileAuthConfirmationWithFingerprint() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleMobileAuthConfirmationWithFingerprint")
        handler?.authenticatorType = .fingerprint
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        handler?.handleMobileAuthConfirmation(cancelled: false)
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHandleMobileAuthConfirmationWithPin() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleMobileAuthConfirmationWithPin")
        handler?.authenticatorType = .pin
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        handler?.handleMobileAuthConfirmation(cancelled: false)
        
        waitForExpectations(timeout: 20, handler: nil)
    }
}
