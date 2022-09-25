//
//  TestRequestFactory.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
@testable import TestSwile

final class TestRequestFactory: XCTestCase {

    func testGetImage() {
        let requestFactory = RequestFactory()

       let request = requestFactory.generateGetImage(imageURL: "https://res.cloudinary.com/hbnjrwllw/image/upload/v1583240999/neobank/charity/cdaa7851-da33-4b3c-8e01-228c4b085ac3.png")

        XCTAssertEqual(request?.httpMethod, "GET")

        XCTAssertEqual(request?.cachePolicy, .useProtocolCachePolicy)

        guard let url = URL(string: "https://res.cloudinary.com/hbnjrwllw/image/upload/v1583240999/neobank/charity/cdaa7851-da33-4b3c-8e01-228c4b085ac3.png") else { fatalError() }

        XCTAssertEqual(request?.url, url)
    }

    func testTransactionRequest() {
        let requestFactory = RequestFactory()

        let request = requestFactory.generateGetTransactionsRequest()
        XCTAssertEqual(request?.httpMethod, "GET")
        guard let url = URL(string: "https://gist.githubusercontent.com/Aurazion/365d587f5917d1478bf03bacabdc69f3/raw/3c92b70e1dc808c8be822698f1cbff6c95ba3ad3/transactions.json") else { fatalError() }

        XCTAssertEqual(request?.url, url)
    }


}
