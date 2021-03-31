//
//  RegistrationHandler_SignUpUITests.swift
//  OneginiUITests
//
//  Created by Patryk Gałach on 31/03/2021.
//

import XCTest
@testable import onegini
import OneginiSDKiOS
import OneginiCrypto

class RegistrationHandler_SignUpUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSignUpWithDummyId() throws {
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        addTeardownBlock {
            app.terminate()
        }

        print("[\(type(of: self))] looking for run with providers button")
        
        let runWithProvidersButton = app.staticTexts["Show menu\nRun with providers"]
        let exists = NSPredicate(format: "exists == 1")

        expectation(for: exists, evaluatedWith: runWithProvidersButton, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        
        print("[\(type(of: self))] button found! lets goooo!")
        
        runWithProvidersButton.tap()
        app.buttons["Dummy-IDP"].tap()
        
        // enter dummy user id
        let textField = app/*@START_MENU_TOKEN@*/.webViews/*[[".otherElements[\"BrowserView?WebViewProcessID=90459\"].webViews",".webViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.webViews.otherElements["Dummy user authenticator — Onegini Token Server"].children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .textField).element
        
        expectation(for: exists, evaluatedWith: textField, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
        
        textField.tap()
        textField.typeText("sometestid\n") // enter id and submit
        
        // pin codes buttons
        let button = app.buttons["5"]
        let button2 = app.buttons["6"]
        let button3 = app.buttons["3"]
        let doneButton = app.buttons["Done"]
        
        // enter pin
        button.tap()
        button.tap()
        
        button2.tap()
        button2.tap()
        
        button3.tap()
        
        doneButton.tap()
        
        // confirm pin
        button.tap()
        button.tap()
        
        button2.tap()
        button2.tap()
        
        button3.tap()
        
        doneButton.tap()
        
        // logout user
        app.buttons["Open navigation menu"].tap()
        app.staticTexts["Log Out"].tap()
    }
}
