import XCTest
@testable import onegini

class DisconnectHandler_DisconnectTests: XCTestCase {
    
    var handler: DisconnectHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = DisconnectHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

    func testDisconnect() throws {
        let expectation = self.expectation(description: "testDisconnect")

        handler?.disconnect(completion: { (error) in
            // check if method return any response
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)
    }
}
