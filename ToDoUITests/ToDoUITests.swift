//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Javal Nanda on 01/10/17.
//  Copyright © 2017 Equal experts. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        app.navigationBars["ToDo.ItemListView"].buttons["Add"].tap()
        
        let titleTextField = app.textFields["Title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")
        
        let dateTextField = app.textFields["Date"]
        dateTextField.tap()
        dateTextField.typeText("10/01/2017")
        
        let locationTextField = app.textFields["Location"]
        locationTextField.tap()
        locationTextField.typeText("Office")
        
        let addressTextField = app.textFields["Address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring Ipad")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.tap()
        app.buttons["Save"].tap()

        XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["10/01/2017"].exists)
        XCTAssertTrue(app.tables.staticTexts["Office"].exists)
    }
    
}
