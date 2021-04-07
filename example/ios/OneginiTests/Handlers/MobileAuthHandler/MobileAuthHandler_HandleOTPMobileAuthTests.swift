import XCTest
@testable import onegini
import OneginiSDKiOS

class MobileAuthHandler_HandleOTPMobileAuthTests: XCTestCase {
    
    var handler: MobileAuthHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = MobileAuthHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testHandleOTPMobileAuthWithChallange() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleOTPMobileAuthWithChallange")
        let otpCode = "someotpcode"
        let customRegistrationChallenge = ONGCustomRegistrationChallenge()
        
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        
        print("[\(type(of: self))] testHandleOTPMobileAuthWithChallange start handler")
        
        handler?.handleOTPMobileAuth(otpCode, customRegistrationChallenge: customRegistrationChallenge, { (data, error) in
            print("[\(type(of: self))] handleOTPMobileAuth completion: \(data.debugDescription) ; e: \(error)")
            expectation.fulfill()
        })
        
        print("[\(type(of: self))] testHandleOTPMobileAuthWithChallange waiting for result")
        
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testHandleOTPMobileAuthWithoutChallenge() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleOTPMobileAuthWithoutChallenge")
        let otpCode = "someotpcode"
        
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        
        handler?.handleOTPMobileAuth(otpCode, customRegistrationChallenge: nil, { (data, error) in
            print("[\(type(of: self))] handleOTPMobileAuth completion: \(data.debugDescription) ; e: \(error)")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 20, handler: nil)
    }
}
