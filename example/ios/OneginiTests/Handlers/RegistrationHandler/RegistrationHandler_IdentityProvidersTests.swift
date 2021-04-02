import XCTest
@testable import onegini
import OneginiSDKiOS

class RegistrationHandler_IdentityProvidersTests: XCTestCase {
    
    var handler: RegistrationHandler?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = RegistrationHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    func testGetIdentityProviders() throws {
        let providers = handler?.identityProviders
        XCTAssertNotNil(providers)
    }
}
