//
//  TravelingCatUITests.swift
//  TravelingCatUITests
//
//  Created by Sirin on 22/04/2018.
//  Copyright © 2018 Sirin K. All rights reserved.
//

import XCTest

class TravelingCatUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {

        super.tearDown()
    }
    
    func testTrip() {
        
        let app = XCUIApplication()
        app.buttons["add button"].tap()
        app.textFields["Enter trip"].tap()
        XCTAssert(app.textFields["Enter trip"].exists)
    }
    
}
