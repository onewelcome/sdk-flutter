import XCTest
@testable import onegini
import OneginiSDKiOS
import OneginiCrypto

class LoginHandler_AuthenticateUserTests: XCTestCase, PinConnectorToPinHandler {
    var handler: LoginHandler?
    
    var onPinProvidedCallback: ((_ pin: String) -> ())?
    var onCancelCallback: (() -> ())?
    var closeFlowCallback: (() -> ())?
    var handleFlowUpdateCallback: ((_ flow: PinFlow, _ error: SdkError?, _ receiver: PinHandlerToReceiverProtocol) -> ())?
    var onChangePinCalledCallback: ((_ pin: String?) -> ())?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        handler = LoginHandler()
        handler!.pinHandler = self
    }

    override func tearDownWithError() throws {
        handler = nil
        try super.tearDownWithError()
    }
    
    func onPinProvided(pin: String) {
        print("[\(type(of: self))] onPinProvided: \(pin)")
        onPinProvidedCallback?(pin)
    }
    
    func onChangePinCalled(completion: @escaping (Bool, SdkError?) -> Void) {
        print("[\(type(of: self))] onChangePinCalled")
        completion(true, nil)
    }
    
    func onCancel() {
        print("[\(type(of: self))] onCancel")
        onCancelCallback?()
    }
    
    func handleFlowUpdate(_ flow: PinFlow, _ error: SdkError?, receiver: PinHandlerToReceiverProtocol) {
        print("[\(type(of: self))] handleFlowUpdate: \(flow) ; \(error?.errorDescription) ; \(receiver)")
        handleFlowUpdateCallback?(flow, error, receiver)
    }
    
    func closeFlow() {
        print("[\(type(of: self))] closeFlow")
        closeFlowCallback?()
    }
    
    func testAuthorizeUserWithPin() throws {
        var expectation = self.expectation(description: "startOneginiModule")
        
        OneginiModuleSwift.sharedInstance.startOneginiModule { (callback) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        expectation = self.expectation(description: "testAuthorizeUserWithPin")
        
        let profile: ONGUserProfile = ONGUserProfile(id: "testId")
        
        handleFlowUpdateCallback = {
            flow, error, receiver in
            print("[\(type(of: self))] handleFlowUpdate callback")
            XCTAssert(flow == .authentication)
            XCTAssertNil(error)
            
            self.handler?.loginCompletion?(profile, error)
        }
        
        addTeardownBlock {
            self.handler?.pinHandler?.closeFlow()
        }
        
        handler?.authenticateUser(profile, authenticator: nil, completion: { (authenticatedUser, error) in
            print("[\(type(of: self))] authenticate user: \(authenticatedUser.debugDescription) ; e: \(error.debugDescription)")
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
