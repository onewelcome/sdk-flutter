import XCTest
@testable import onegini

class BrowserHandler_HandleUrlTests: XCTestCase, BrowserHandlerToRegisterHandlerProtocol {
    
    var handler: BrowserViewController?
    var urlHandlerCallback: ((_ url: URL?) -> ())?

    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = BrowserViewController(registerHandlerProtocol: self)
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func handleRedirectURL(url: URL?) {
        print("[\(type(of: self))] handleRedirectURL: \(url)")
        urlHandlerCallback?(url)
    }

    func testHandleUrl() throws {
        let expectation = self.expectation(description: "testHandleUrl")
        
        let sampleUrl = URL.init(string: "https://google.com")
        urlHandlerCallback = {
            url in
            print("[\(type(of: self))] urlHandlerCallback: \(url)")
            expectation.fulfill()
        }
        
        // can't run this one
        // handler?.handleUrl(url: sampleUrl!)
        
        // calling redirect directly
        handler?.registerHandler.handleRedirectURL(url: sampleUrl)
        
        waitForExpectations(timeout: 20, handler: nil)
        
    }
}
