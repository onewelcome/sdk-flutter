import XCTest
@testable import onegini

class AppToWebHandler_SignInAppToWebTests: XCTestCase {

    var handler: AppToWebHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = AppToWebHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testSignInAppToWeb() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testSignInAppToWeb")
        
        let sampleUrl = URL.init(string: "https://google.com")
        handler?.signInAppToWeb(targetURL: sampleUrl, completion: { (data, error) in
            // check if method return any response
            print("[\(type(of: self))] completion in signInAppToWeb: \((data?.debugDescription ?? "nil")) ; e: \((error?.errorDescription ?? "nil"))")
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
