//
//  TestDetailViewModel.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
import Combine
@testable import TestSwile

final class TestDetailViewModel: XCTestCase {

    func testDetailViewModel() async {
        let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)
        do {
            let transaction = try await manager.getTransactions()
            let delegateFullFill = XCTestExpectation()
            let delegate = DetailDelegateTester(expect: delegateFullFill)
            guard let firstModel = transaction.first else { fatalError() }
            let detailViewModel = TransactionDetailViewModel(model: firstModel, manager: manager)
            detailViewModel.delegate = delegate
            let price = NumberFormatter.formatPrice(price: -0.07, currency: "EUR")
            XCTAssertEqual(detailViewModel.priceTitle, price)
            XCTAssertEqual(detailViewModel.subTitle, "Restos du coeur")
            guard let date = DateFormatter.isoFormater.date(from: "2021-03-07T14:04:45.000+01:00") else { fatalError() }
            let dateStr = DateFormatter.fullDateFormatter.string(from: date).capitalizedSentence
            XCTAssertEqual(detailViewModel.dateTitle, dateStr)
            detailViewModel.userDidTapOnBackButton()
            wait(for: [delegateFullFill], timeout: 3)
        } catch {
            fatalError()
        }

    }

}


class DetailDelegateTester: TransactionDetailViewModelDelegate {

    let expect: XCTestExpectation

    init(expect: XCTestExpectation) {
        self.expect = expect
    }

    func detailViewModelUserDidTapOnBackButton(_ viewModel: TestSwile.TransactionDetailViewModel) {
        self.expect.fulfill()
    }


}

