//
//  TestSwileUITests.swift
//  TestSwileUITests
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import XCTest

final class TestSwileUITests: XCTestCase {


    func testCellElements() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.tables.matching(identifier: "Transaction List").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Cell Image").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Cell Title").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Cell SubTitle").element.exists)
        
    }


    func testOpenDetail() throws {
        let app = XCUIApplication()
        app.launch()

        let tablesQuery = app.tables.matching(identifier: "Transaction List")
        XCTAssert(app.tables.matching(identifier: "Transaction List").element.exists)

        tablesQuery.children(matching: .cell).element(boundBy: 3).tap()

        _ = app.otherElements.matching(identifier: "Transaction Detail").element.waitForExistence(timeout: 10)
        XCTAssert(app.otherElements.matching(identifier: "Transaction Detail").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail Titre Resto").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail Addition share").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail love").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail problem").element.exists)

        XCTAssert(app.staticTexts.matching(identifier: "Detail Price").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Detail Name").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Detail Date").element.exists)

        app.buttons.matching(identifier: "Back Button").element.tap()
        _ = tablesQuery.element.waitForExistence(timeout: 10)
    }
}
