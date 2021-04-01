import XCTest
@testable import onegini

class RegistrationHandler_DeregisterTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testDeregister() throws {
        
        let expectation = self.expectation(description: "testDeregister")
        
        handler?.deregister(completion: { (error) in
            print("[\(type(of: self))] deregister e: \(error?.errorDescription ?? "nil")")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
