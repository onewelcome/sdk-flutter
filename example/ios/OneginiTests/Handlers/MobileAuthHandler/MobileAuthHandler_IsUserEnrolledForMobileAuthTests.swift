import XCTest
@testable import onegini
import OneginiSDKiOS

class MobileAuthHandler_IsUserEnrolledForMobileAuthTests: XCTestCase {
    
    var handler: MobileAuthHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = MobileAuthHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testIsUserEnrolledForMobileAuth() throws {
        let expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        let userClient = ONGUserClient()
        let enrolled = handler?.isUserEnrolledForMobileAuth(userClient: userClient)
        print("[\(type(of: self))] enrolled: \(enrolled)")
    }
}
