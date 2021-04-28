import XCTest
@testable import onegini
import OneginiSDKiOS

class MobileAuthHandler_HandleQrOTPMobileAuthTests: XCTestCase {
    
    var handler: MobileAuthHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = MobileAuthHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testHandleQrOTPMobileAuth() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testHandleQrOTPMobileAuth")
        let otpCode = "someotpcode"
        let customRegistrationChallenge = ONGCustomRegistrationChallenge()
        
        handler?.confirmation = { cancelled in
            print("[\(type(of: self))] confirmation: cancelled: \(cancelled)")
            expectation.fulfill()
        }
        
        handler?.handleQrOTPMobileAuth(otpCode, customRegistrationChallenge: customRegistrationChallenge, { (data, error) in
            print("[\(type(of: self))] handleQrOTPMobileAuth completion: \(data.debugDescription) ; e: \(error)")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 20, handler: nil)
    }
}
