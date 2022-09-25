//
//  TestViewModel.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
import Combine
@testable import TestSwile

final class TestListViewModel: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testViewDidAppear() {

        let expectSpinner = XCTestExpectation()
        let expectSpinnerFalse = XCTestExpectation()

        let expectShouldReloadList = XCTestExpectation()

        let expectDisplayResult = XCTestExpectation()

    	let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)

        let listViewModel = TransactionListViewModel(manager: manager)

        listViewModel.shouldDisplaySpinner.receive(on: DispatchQueue.main).sink { shouldDisplaySpinner in
            if shouldDisplaySpinner == true {
                expectSpinner.fulfill()
            } else {
                expectSpinnerFalse.fulfill()
            }
        }.store(in: &self.cancellables)

        listViewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { shoulReloadList in
            if shoulReloadList == true {
                expectShouldReloadList.fulfill()
            }

            if listViewModel.transactionModel.count == 3 {
                guard let date = DateFormatter.isoFormater.date(from: "2021-03-07T14:04:45.000+01:00") else {
                    fatalError()
                }
                let str = DateFormatter.monthDateFormater.string(from: date).capitalized
                XCTAssertEqual(listViewModel.transactionModel.first?.name, str)
                XCTAssertEqual(listViewModel.transactionModel.first?.transactions.count, 4)
                expectDisplayResult.fulfill()
            }

        }.store(in: &cancellables)

        listViewModel.viewDidAppear()

        wait(for: [expectSpinner, expectSpinnerFalse, expectShouldReloadList, expectDisplayResult], timeout: 20)
    }

    func testViewDidAppearError() {
        let apiManager = APIMockManager(error: true)
        let manager = TransactionManager(apiService: apiManager)

        let listViewModel = TransactionListViewModel(manager: manager)

        let alertExpect = XCTestExpectation()

        listViewModel.alertModel.receive(on: DispatchQueue.main).sink { alertModel in
            if alertModel != nil {
                alertExpect.fulfill()
                XCTAssertEqual(alertModel?.title, NSLocalizedString("error.title", comment: ""))
                XCTAssertEqual(alertModel?.subTitle, NSLocalizedString("error.internet", comment: ""))
                XCTAssertEqual(alertModel?.buttonActions.first?.name, NSLocalizedString("error.retry", comment: ""))
            }


        }.store(in: &cancellables)

        listViewModel.viewDidAppear()
        wait(for: [alertExpect], timeout: 20)
    }

    func testPagination() {
        let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)

        let listViewModel = TransactionListViewModel(manager: manager)

        let paginationExpectation = XCTestExpectation()

        listViewModel.viewDidAppear()

        listViewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { shouldReload in
            if shouldReload == true {
                listViewModel.userDidReachTheEndOfTheList()
            }
        }.store(in: &self.cancellables)

        listViewModel.toInsert.receive(on: DispatchQueue.main).sink { sections in

            if sections != nil {
                paginationExpectation.fulfill()
            }

        }.store(in: &self.cancellables)


        wait(for: [paginationExpectation], timeout: 20)
    }

    func testUserSelection() {

        let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)

        let listViewModel = TransactionListViewModel(manager: manager)
        let delegateExpect = XCTestExpectation()

        let delegate = ListDelegateObject(expect: delegateExpect)

        listViewModel.delegate = delegate

        listViewModel.viewDidAppear()

        listViewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { shouldReload in
            if shouldReload == true {
                listViewModel.userDidTapOnElementAtIndexPath(indexPath: IndexPath(item: 0, section: 0))
            }
        }.store(in: &self.cancellables)

        wait(for: [delegateExpect], timeout: 20)
    }

}


class ListDelegateObject: TransactionListViewModelDelegate {

    let expect: XCTestExpectation

    init(expect: XCTestExpectation) {
        self.expect = expect
    }

    func transactionListViewModel(_ viewModel: TransactionListViewModel, userDidTapOnTransaction: TransactionModel) {
        self.expect.fulfill()
    }
}
