//
//  TestSwileTests.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import XCTest
@testable import TestSwile

final class TestManager: XCTestCase {

    func testGetImage() async {
        let apiMock = APIMockManager()
        let manager = TransactionManager(apiService: apiMock)

        do {
    		let dest = try await manager.getImage(imageURL: "ffefefew")
            XCTAssertNotNil(dest)
        } catch {
            fatalError()
        }

    }

    func testGetCachedImage() async {
        let apiMock = APIMockManager()
        let manager = TransactionManager(apiService: apiMock)

        do {
            let dest = try manager.getCachedImage(imageURL: "ffke;l")
            XCTAssertNotNil(dest)
        } catch {
            fatalError()
        }

    }

    func testGetTransaction() async {

        let apiMock = APIMockManager()
        let manager = TransactionManager(apiService: apiMock)

        do {
            let dest = try await manager.getTransactions()

            guard let first = dest.first else { fatalError() }

            guard let date = DateFormatter.isoFormater.date(from: "2021-03-07T14:04:45.000+01:00") else {fatalError() }

            XCTAssertEqual(first.name, "Restos du coeur")
            XCTAssertEqual(first.type, "donation")
            XCTAssertEqual(first.date, date)
            XCTAssertEqual(first.message, "Don à l'arrondi")

            XCTAssertEqual(first.amount.value, -0.07)
            XCTAssertEqual(first.amount.currency.iso3, "EUR")
            XCTAssertEqual(first.amount.currency.symbol, "€")
            XCTAssertEqual(first.amount.currency.title, "Euro")

            XCTAssertEqual(first.smallIcon.url, nil)
            XCTAssertEqual(first.smallIcon.category, "meal_voucher")

            XCTAssertEqual(first.largeIcon.url, "https://res.cloudinary.com/hbnjrwllw/image/upload/v1583240999/neobank/charity/cdaa7851-da33-4b3c-8e01-228c4b085ac3.png")
            XCTAssertEqual(first.largeIcon.category, "donation")
            XCTAssertEqual(dest.count, 8)
        } catch {
        	fatalError("Error retrieving transaction")
        }

    }

}
