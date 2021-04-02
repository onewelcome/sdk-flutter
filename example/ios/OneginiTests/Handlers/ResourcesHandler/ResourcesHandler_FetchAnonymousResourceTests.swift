import XCTest
@testable import onegini

class ResourcesHandler_FetchAnonymousResourceTests: XCTestCase {

    var handler: ResourcesHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = ResourcesHandler()
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func testFetchAnonymousResource() throws {
        var expectation = self.expectation(description: "startOneginiModule")

        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        expectation = self.expectation(description: "testFetchAnonymousResource")

        var parameters = [String: Any]()
        parameters["path"] = "devices"
        parameters["encoding"] = "application/x-www-form-urlencoded";
        parameters["method"] = "application-details"

        handler?.fetchAnonymousResource("application-details", parameters: parameters, completion: { (result) in
            print("resullll")
            print((result as! FlutterError).details)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
