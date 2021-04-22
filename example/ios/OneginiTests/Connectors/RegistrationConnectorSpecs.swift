//
//  RegistrationConnectorSpecs.swift
//  OneginiTests
//
//  Created by Patryk Gałach on 22/04/2021.
//

import Quick
import Nimble
@testable import onegini

class RegistrationConnectorSpecs: QuickSpec {
    override func spec() {
        
        var someText: String = ""
        
        describe("Sample Setting") {
        
            context("setting someText") {
                afterEach {
                    someText = ""
                }
                
                beforeEach {
                    someText = "hello!"
                }
                
                it("has value?") {
                    expect(someText).toNot(equal(""))
                }
                it("is it 'hello!'?") {
                    expect(someText).to(equal("hello!"))
                }
            }
            
        }
    }
}
