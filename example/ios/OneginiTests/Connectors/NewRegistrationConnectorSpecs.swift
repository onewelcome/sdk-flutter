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
        
        describe("Registration connector") {
            afterEach {
                let method = FlutterMethodCall()
                let result: FlutterResult = { val in
                    
                }
                connector?.cancel(method, result)
                connector = nil
            }
            
            beforeEach {
                connector = NewRegistrationConnector.init(registrationWrapper: simpleMockRegWrapper, identityProvider: TestIdentityProviderConnector(), userProfile: TestUserProfileConnector(), browserRegistrationRequest: browserConnector, pinRegistrationRequest: pinConnector)
                connector?.flutterConnector = flutterConnector
            }
            
            describe("when call with register method") {
            
                it("should call register method in wrapper") {
                    
                    let parameters = self.configureRegMethodInputParameters()
                    //connector?.register(parameters.call, parameters.result)
                    
                    //expect(simpleMockRegWrapper.didRegister).to(beTrue())
                    XCTAssert(simpleMockRegWrapper.didRegister == true)
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
                }
            }
        }
    }
    
    // Input data: register user method - fetch registration url
    func configureRegMethodInputParameters() -> (call: FlutterMethodCall, result: FlutterResult) {
        let method = FlutterMethodCall(
            methodName: Constants.Routes.registerUser,
            arguments: [Constants.Parameters.identityProviderId: nil,
                        Constants.Parameters.scopes: ["read"]])
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

class SimpleMockRegistrationWrapper: RegistrationWrapperProtocol {
    var registerScopes: [String]?
    var didRegister: Bool = false
    
    var createPin: ((CreatePinChallengeProtocol) -> Void)?
    
    var browserRegistration: ((BrowserRegistrationChallengeProtocol) -> Void)?
    
    var registrationSuccess: ((ONGUserProfile, ONGCustomInfo?) -> Void)?
    
    var registrationFailed: ((Error) -> Void)?
    
    func register(identityProvider: ONGIdentityProvider?, scopes: Array<String>?) {
        registerScopes = scopes
        didRegister = true
    }
}
