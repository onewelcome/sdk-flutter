import XCTest
@testable import onegini

class RegistrationHandler_LogoutTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testLogout() throws {
        let expectation = self.expectation(description: "testLogout")
        
        handler?.logout(completion: { (error) in
            // check if method return any response
            print("[\(type(of: self))] logout e: \(error?.errorDescription ?? "nil")")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
