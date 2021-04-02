import XCTest
@testable import onegini

class ResourcesHandler_FetchResourceWithImplicitResourceTests: XCTestCase {

    var handler: ResourcesHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = ResourcesHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }

}
