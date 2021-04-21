import XCTest
@testable import onegini

class MobileAuthHandler_EnrollForMobileAuthTests: XCTestCase {
    
    var handler: MobileAuthHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = MobileAuthHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testEnrollForMobileAuth() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testEnrollForMobileAuth")
        
        handler?.enrollForMobileAuth({ (success, error) in
            print("[\(type(of: self))] enrollForMobileAuth completion: \(success) ; e: \(error)")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
