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
        parameters["path"] = "application-details"
        parameters["scope"] = "application-details"

        handler?.fetchAnonymousResource("application-details", parameters: parameters, completion: { (result) in
            print("[\(type(of: self))] completion: \(result.debugDescription)")
            if let error = result as? FlutterError {
                print("[\(type(of: self))] error: \(error.description)")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
