import XCTest
@testable import onegini

class RegistrationHandler_SignUpTests: XCTestCase, BrowserHandlerProtocol {
    var handler: RegistrationHandler?
    var urlHandlerCallback: ((_ url: URL?) -> ())?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
        handler?.browserConntroller = self
    }

    override func tearDownWithError() throws {
        handler?.cancelRegistration()
        handler = nil
        try super.tearDownWithError()
    }
    
    func handleUrl(url: URL) {
        urlHandlerCallback?(url)
    }
    
    func testSignUpWithDummyId() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = self.expectation(description: "testSignUpWithDummyId")
        
        urlHandlerCallback = {
            url in
            XCTAssertNotNil(url)
            expectation.fulfill()
        }
        
        addTeardownBlock {
            self.handler?.cancelRegistration()
        }
        
        // TODO: handle sign up without browser or find better way
        let dummyProviderId = "Dummy-IDP"
        handler?.signUp(dummyProviderId, completion: { (_, _, _) in })
        
        waitForExpectations(timeout: 40, handler: nil)
    }
    
    func testSignUpWithInvalidId() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = self.expectation(description: "testSignUpWithInvalidId")
        
        let invalidProviderId = "some-invalid-provider-id"
        handler?.signUp(invalidProviderId, completion: { (success, userProfile, error) in
            
            print("[REGISTRATIONHANDLER] sign complete with invalid")
            print("[REGISTRATIONHANDLER] success: \(success) ; profile: \(userProfile.debugDescription) ; error: \(error!.errorDescription)")
            
            XCTAssertFalse(success)
            XCTAssertNil(userProfile)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
