//
//  TestImageViewModel.swift
//  TestSwileTests
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import XCTest
import Combine
@testable import TestSwile

final class TestCellViewModel: XCTestCase {

    private var cancellables = Set<AnyCancellable>()

    func testCellImageViewModel() {

        let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)
        let imageDownloader = ImageDownloaderServiceMock()

        let listViewModel = TransactionListViewModel(manager: manager,imageDownloader: imageDownloader)

        let imageViewModelExpect = XCTestExpectation()
        let remoteImage = XCTestExpectation()
        let accessoryRemoteImage = XCTestExpectation()

        listViewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { shouldReloadList in
            if shouldReloadList == true {
                guard let firstSection = listViewModel.transactionModel.first,
                      let firstCellViewModel = firstSection.transactions.first else { fatalError() }
               XCTAssertEqual(firstCellViewModel.imageViewModel.acessoryPicto, SWKit.CategoriesIcons.meal_voucher.image)
                XCTAssertEqual(firstCellViewModel.imageViewModel.borderColor, SWKit.Colors.donationBorderColor)
                XCTAssertEqual(firstCellViewModel.imageViewModel.backgroundColor, SWKit.Colors.donationColor)
                XCTAssertEqual(firstCellViewModel.imageViewModel.picto, nil)

                firstCellViewModel.imageViewModel.remoteImage.receive(on: DispatchQueue.main).sink { image in
                    if image != nil {
                        remoteImage.fulfill()
                    }
                }.store(in: &self.cancellables)
                imageViewModelExpect.fulfill()

                guard let lastCellViewModel = listViewModel.transactionModel.last?.transactions.last else { fatalError() }

                lastCellViewModel.imageViewModel.remoteImage.receive(on: DispatchQueue.main).sink { image in
                    if image != nil {
                        accessoryRemoteImage.fulfill()
                    }
                }.store(in: &self.cancellables)
            }
        }.store(in: &cancellables)

        listViewModel.viewDidAppear()
        wait(for: [imageViewModelExpect, remoteImage, accessoryRemoteImage], timeout: 20)
    }

    func testCellViewModel() {
        let apiManager = APIMockManager()
        let manager = TransactionManager(apiService: apiManager)
        let imageDownloader = ImageDownloaderServiceMock()

        let listViewModel = TransactionListViewModel(manager: manager, imageDownloader: imageDownloader)

        let cellViewModelExpect = XCTestExpectation()

        listViewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { shouldReloadList in
            if shouldReloadList == true {
                guard let firstSection = listViewModel.transactionModel.first,
                      let firstCellViewModel = firstSection.transactions.first else { fatalError() }
                XCTAssertEqual(firstCellViewModel.title, "Restos du coeur")
                guard let date = DateFormatter.isoFormater.date(from: "2021-03-07T14:04:45.000+01:00") else { fatalError() }
                let str = DateFormatter.shortDateFormatter.string(from: date) + "・" + "Don à l'arrondi"
                XCTAssertEqual(firstCellViewModel.subTitle, str)

                let price = NumberFormatter.formatPrice(price: -0.07, currency: "EUR")

                XCTAssertEqual(firstCellViewModel.price, price)
                XCTAssertEqual(firstCellViewModel.priceIsPositive, false)
                cellViewModelExpect.fulfill()

            }
        }.store(in: &cancellables)

        listViewModel.viewDidAppear()
		wait(for: [cellViewModelExpect], timeout: 20)

    }

}
