import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

class NewRegistrationConnectorSpecs: QuickSpec {
    
    override func spec() {
        
        var connector: NewRegistrationConnector?
        let flutterConnector = TestFlutterListener()
        let browserConnector = BrowserRequestConnector()
        let pinConnector = PinRequestConnector()
        let simpleMockRegWrapper = SimpleMockRegistrationWrapper()
        
        var scopes: [String]?
        var identityProvider: String?
        
        describe("Registration connector") {
            afterEach {
            }
            
            beforeEach {
                connector = NewRegistrationConnector.init(registrationWrapper: simpleMockRegWrapper, identityProvider: SimpleMockIdentityProvider(), userProfile: TestUserProfileConnector(), browserRegistrationRequest: browserConnector, pinRegistrationRequest: pinConnector)
                connector?.flutterConnector = flutterConnector
            }
            
            describe("when calling with register method") {
            
                describe("should call register method in wrapper") {
                    var parameters: (call: FlutterMethodCall, result: FlutterResult)!
                    
                    beforeEach {
                        scopes = ["read"]
                        identityProvider = "TestId"//
                        
                        parameters = self.configureRegMethodInputParameters(identityProviderId: identityProvider, scopes: scopes)
                    }
                    
                    afterEach {
                        scopes = nil
                        identityProvider = nil
                    }
                    
                    it("with proper parameters") {
                        // with proper parameters
                        // to check whether input parameters are accepted
                        connector?.register(parameters.call, parameters.result)
                        expect(simpleMockRegWrapper.didRegister).to(beTrue())
                        expect(simpleMockRegWrapper.registerScopes).toNot(beNil())
                        expect(simpleMockRegWrapper.identityProvider?.identifier).to(equal("TestId"))
                        
                    }
                }
                
                
                   
            }
        }
    }
    
    // Input data: register user method - fetch registration url
    func configureRegMethodInputParameters(identityProviderId: String?, scopes: [String]?) -> (call: FlutterMethodCall, result: FlutterResult) {
        let method = FlutterMethodCall(
            methodName: Constants.Routes.registerUser,
            arguments: [Constants.Parameters.identityProviderId: identityProviderId,
                        Constants.Parameters.scopes: scopes])
        let result: FlutterResult = { val in /* don't need result in this case */}
        
        return (method, result)
    }
    
    func configureRegMethodResponce(data: String) -> (name: String?, value: String?, error: Error?) {
        do {
            let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
            let name = json[Constants.Parameters.eventName]
            let value = json[Constants.Parameters.eventValue]
            
            return (name, value, nil)
        } catch {
            print(error)
            return (nil, nil, error)
        }
    }
}

class SimpleMockIdentityProviderObject: ONGIdentityProvider {
    convenience init(id: String) {
        self.init()
        
        identifier = id
    }
}

class SimpleMockRegistrationWrapper: RegistrationWrapperProtocol {
    var registerScopes: [String]?
    var identityProvider: ONGIdentityProvider?
    var didRegister: Bool = false
    
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)?
    
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    
    var registrationFailed: ((Error) -> Void)?
    
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        self.registerScopes = scopes
        self.identityProvider = identityProvider
        self.didRegister = true
    }
}

class SimpleMockIdentityProvider: IdentityProviderConnectorProtocol {
    func getIdentityProviders(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
    }
    
    func getIdentityProviders() -> Array<ONGIdentityProvider> {
        return []
    }
    
    func getIdentityProviderWith(providerId: String?) -> ONGIdentityProvider? {
        return SimpleMockIdentityProviderObject.init(id: "TestId")
    }
    

}


//XCTAssert(simpleMockRegWrapper.didRegister == true)
//                    waitUntil { done in
//
//                        flutterConnector.receiveEvent = {
//                            eventName, eventData in
//
//                            expect(eventName).to(equal(.registrationNotification))
//
//                            let data = eventData as! String
//                            let result = self.configureRegMethodResponce(data: data)
//
//                            expect(result.name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                            expect(result.value).toNot(beNil())
//
//                            let url = URL.init(string: result.value!)
//                            expect(url).toNot(beNil())
//
//                            done()
//                        }
//
//                        let parameters = self.configureRegMethodInputParameters()
//                        connector?.register(parameters.call, parameters.result)
//
//                    }
