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

        XCTAssert(app.tables["Transaction List"].children(matching: .cell).matching(identifier: "Transaction cell").element(boundBy: 2).children(matching: .staticText).matching(identifier: "Cell Title").element.exists)

        XCTAssert(app.tables["Transaction List"].children(matching: .cell).matching(identifier: "Transaction cell").element(boundBy: 2).children(matching: .staticText).matching(identifier: "Cell SubTitle").element.exists)


        XCTAssert(app.tables["Transaction List"].children(matching: .cell).matching(identifier: "Transaction cell").element(boundBy: 2).children(matching: .other).matching(identifier: "Cell Image").element.exists)
        
    }


    func testOpenDetail() throws {

        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.tables.matching(identifier: "Transaction List").element.exists)

        app.tables["Transaction List"].children(matching: .cell).matching(identifier: "Transaction cell").element(boundBy: 2).children(matching: .other).element(boundBy: 0).tap()

        XCTAssert(app.otherElements.matching(identifier: "Transaction Detail").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail Titre Resto").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail Addition share").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail love").element.exists)
        XCTAssert(app.otherElements.matching(identifier: "Detail problem").element.exists)

        XCTAssert(app.staticTexts.matching(identifier: "Detail Price").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Detail Name").element.exists)
        XCTAssert(app.staticTexts.matching(identifier: "Detail Date").element.exists)

        app.buttons.matching(identifier: "Back Button").element.tap()

        XCTAssert(app.tables.matching(identifier: "Transaction List").element.exists)
    }
}
