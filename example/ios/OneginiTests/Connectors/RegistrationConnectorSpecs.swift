//
//  RegistrationConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 22/04/2021.
//

import Quick
import Nimble
import OneginiSDKiOS
@testable import onegini

//class RegistrationConnectorSpecs: QuickSpec {
//    
//    override func spec() {
//        
//        var connector: NewRegistrationConnector?
//        let flutterConnector = TestFlutterListener()
//        let browserConnector = BrowserRequestConnector()
//        let pinConnector = PinRequestConnector()
//        
//        describe("registration connector") {
//            
//            afterEach {
//                let method = FlutterMethodCall()
//                let result: FlutterResult = { val in
//                    
//                }
//                connector?.cancel(method, result)
//                connector = nil
//            }
//            
//            beforeEach {
//                connector = NewRegistrationConnector.init(registrationWrapper: TestRegistrationWrapper(), identityProvider: TestIdentityProviderConnector(), userProfile: TestUserProfileConnector(), browserRegistrationRequest: browserConnector, pinRegistrationRequest: pinConnector)
//                connector?.flutterConnector = flutterConnector
//            }
//            
//            describe("handling url") {
//            
//                it("expect open url event") {
//                    
//                    waitUntil { done in
//                        
//                        flutterConnector.receiveEvent = {
//                            eventName, eventData in
//                            
//                            expect(eventName).to(equal(.registrationNotification))
//                            
//                            let data = eventData as! String
//                            do {
//                                
//                                let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
//                                let name = json[Constants.Parameters.eventName]
//                                let value = json[Constants.Parameters.eventValue]
//                                
//                                expect(name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                                expect(value).toNot(beNil())
//                                
//                                let url = URL.init(string: value!)
//                                expect(url).toNot(beNil())
//                                
//                            } catch {
//                                print(error)
//                                expect(false).to(beTrue())
//                            }
//
//                            done()
//                        }
//                        
//                        let method = FlutterMethodCall(
//                            methodName: Constants.Routes.registerUser,
//                            arguments: [Constants.Parameters.identityProviderId: nil,
//                                        Constants.Parameters.scopes: ["read"]])
//                        let result: FlutterResult = { val in /* don't need result in this case */}
//                        
//                        connector?.register(method, result)
//                        
//                    }
//                }
//                
//            }
//            
//            describe("handling pin") {
//            
//                it("expect create pin event") {
//                    
//                    waitUntil { done in
//                        
//                        flutterConnector.receiveEvent = {
//                            eventName, eventData in
//                            
//                            expect(eventName).to(equal(.registrationNotification))
//                            let data = eventData as! String
//                            
//                            if data != Constants.Events.eventOpenCreatePin.rawValue {
//                                do {
//                                    
//                                    let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
//                                    let name = json[Constants.Parameters.eventName]
//                                    let value = json[Constants.Parameters.eventValue]
//                                    
//                                    expect(name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                                    expect(value).toNot(beNil())
//                                    
//                                    let url = URL.init(string: value!)
//                                    expect(url).toNot(beNil())
//                                    
//                                    let method = FlutterMethodCall(
//                                        methodName: Constants.Routes.openUrl,
//                                        arguments: [Constants.Parameters.url: "http://test.com"])
//                                    let result: FlutterResult = { val in /* don't need result in this case */}
//                                    
//                                    browserConnector.acceptUrl(method, result)
//                                    
//                                } catch {
//                                    print(error)
//                                    expect(false).to(beTrue())
//                                }
//                                
//                                return
//                            }
//                            
//                            expect(data).to(equal(Constants.Events.eventOpenCreatePin.rawValue))
//                            
//                            done()
//                        }
//                        
//                        let method = FlutterMethodCall(
//                            methodName: Constants.Routes.registerUser,
//                            arguments: [Constants.Parameters.identityProviderId: nil,
//                                        Constants.Parameters.scopes: ["read"]])
//                        let result: FlutterResult = { val in /* don't need result in this case */}
//                        
//                        connector?.register(method, result)
//                        
//                    }
//                }
//                
//            }
//            
//            describe("handling registration") {
//                
//                it("expect registration completion") {
//                    
//                    waitUntil { done in
//                        
//                        flutterConnector.receiveEvent = {
//                            eventName, eventData in
//                            
//                            expect(eventName).to(equal(.registrationNotification))
//                            let data = eventData as! String
//                            
//                            if data != Constants.Events.eventOpenCreatePin.rawValue {
//                                do {
//                                    
//                                    let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
//                                    let name = json[Constants.Parameters.eventName]
//                                    let value = json[Constants.Parameters.eventValue]
//                                    
//                                    expect(name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                                    expect(value).toNot(beNil())
//                                    
//                                    let url = URL.init(string: value!)
//                                    expect(url).toNot(beNil())
//                                    
//                                    let method = FlutterMethodCall(
//                                        methodName: Constants.Routes.openUrl,
//                                        arguments: [Constants.Parameters.url: "http://test.com"])
//                                    let result: FlutterResult = { val in /* don't need result in this case */}
//                                    
//                                    browserConnector.acceptUrl(method, result)
//                                    
//                                } catch {
//                                    // fail test
//                                    expect(false).to(beTrue())
//                                }
//                                
//                                return
//                            }
//                            
//                            if data == Constants.Events.eventOpenCreatePin.rawValue {
//                                
//                                let method = FlutterMethodCall(
//                                    methodName: Constants.Routes.acceptPinRegistrationRequest,
//                                    arguments: [Constants.Parameters.pin: "12345"])
//                                let result: FlutterResult = { val in /* don't need result in this case */}
//                                
//                                pinConnector.acceptPin(method, result)
//                                
//                                return
//                            }
//                            
//                        }
//                        
//                        let method = FlutterMethodCall(
//                            methodName: Constants.Routes.registerUser,
//                            arguments: [Constants.Parameters.identityProviderId: nil,
//                                        Constants.Parameters.scopes: ["read"]])
//                        let result: FlutterResult = { val in
//                            
//                            let userId = val as! String
//                            
//                            expect(userId).toNot(beNil())
//                            
//                            done()
//                        }
//                        
//                        connector?.register(method, result)
//                        
//                    }
//                }
//                
//                
//                describe("handling cancelations") {
//                
//                    it("expect registration cancelation") {
//                        
//                        waitUntil { done in
//                            
//                            let method = FlutterMethodCall(
//                                methodName: Constants.Routes.cancelRegistration,
//                                arguments: [])
//                            let result: FlutterResult = { val in
//                                
//                                done()
//                            }
//                            
//                            connector?.cancel(method, result)
//                        }
//                    }
//                    
//                    it("cancel on open url event") {
//                        
//                        waitUntil { done in
//                            
//                            flutterConnector.receiveEvent = {
//                                eventName, eventData in
//                                
//                                expect(eventName).to(equal(.registrationNotification))
//                                
//                                let data = eventData as! String
//                                do {
//                                    
//                                    let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
//                                    let name = json[Constants.Parameters.eventName]
//                                    let value = json[Constants.Parameters.eventValue]
//                                    
//                                    expect(name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                                    expect(value).toNot(beNil())
//                                    
//                                    let url = URL.init(string: value!)
//                                    expect(url).toNot(beNil())
//                                    
//                                    let method = FlutterMethodCall(
//                                        methodName: Constants.Routes.cancelRegistration,
//                                        arguments: [])
//                                    let result: FlutterResult = { val in /* don't need result in this case */ }
//                                    
//                                    connector?.cancel(method, result)
//                                    
//                                } catch {
//                                    print(error)
//                                    expect(false).to(beTrue())
//                                }
//
//                            }
//                            
//                            let method = FlutterMethodCall(
//                                methodName: Constants.Routes.registerUser,
//                                arguments: [Constants.Parameters.identityProviderId: nil,
//                                            Constants.Parameters.scopes: ["read"]])
//                            let result: FlutterResult = { val in
//                                
//                                print("result for registration: \(String.init(describing: val))")
//                                done()
//                            }
//                            
//                            connector?.register(method, result)
//                            
//                        }
//                    }
//                        
//                        
//                    it("cancel on create pin event") {
//                        
//                        waitUntil { done in
//                            
//                            flutterConnector.receiveEvent = {
//                                eventName, eventData in
//                                
//                                expect(eventName).to(equal(.registrationNotification))
//                                let data = eventData as! String
//                                
//                                if data != Constants.Events.eventOpenCreatePin.rawValue {
//                                    do {
//                                        
//                                        let json = try JSONDecoder().decode(Dictionary<String,String>.self, from: data.data(using: .utf8)!)
//                                        let name = json[Constants.Parameters.eventName]
//                                        let value = json[Constants.Parameters.eventValue]
//                                        
//                                        expect(name).to(equal(Constants.Events.eventOpenUrl.rawValue))
//                                        expect(value).toNot(beNil())
//                                        
//                                        let url = URL.init(string: value!)
//                                        expect(url).toNot(beNil())
//                                        
//                                        let method = FlutterMethodCall(
//                                            methodName: Constants.Routes.openUrl,
//                                            arguments: [Constants.Parameters.url: "http://test.com"])
//                                        let result: FlutterResult = { val in /* don't need result in this case */}
//                                        
//                                        browserConnector.acceptUrl(method, result)
//                                        
//                                    } catch {
//                                        print(error)
//                                        expect(false).to(beTrue())
//                                    }
//                                    
//                                    return
//                                }
//                                
//                                expect(data).to(equal(Constants.Events.eventOpenCreatePin.rawValue))
//                                
//                                
//                                let method = FlutterMethodCall(
//                                    methodName: Constants.Routes.cancelRegistration,
//                                    arguments: [])
//                                let result: FlutterResult = { val in /* don't need result in this case */}
//                                
//                                connector?.cancel(method, result)
//                                
//                            }
//                            
//                            let method = FlutterMethodCall(
//                                methodName: Constants.Routes.registerUser,
//                                arguments: [Constants.Parameters.identityProviderId: nil,
//                                            Constants.Parameters.scopes: ["read"]])
//                            let result: FlutterResult = { val in
//                                
//                                print("result for registration: \(String.init(describing: val))")
//                                done()
//                            }
//                            
//                            connector?.register(method, result)
//                            
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
