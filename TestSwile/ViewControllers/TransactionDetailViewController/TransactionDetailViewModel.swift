//
//  TransactionDetailViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - TransactionDetailViewModel

/// Describe how to display transaction detail and handle user interaction
class TransactionDetailViewModel: TransactionDetailViewModelInterface {

    // MARK: Public properties

    /// Describe transaction image
    let imageViewModel: TransactionImageViewModelInterface

    /// Describe the transaction price
    let priceTitle: String

    /// Describe the transaction subtile (transaction name)
    let subTitle: String

    /// Describe the transaction date in a long format (Mardi 23 Fevrier, 09:34)
    let dateTitle: String

    /// ViewModel delegate, the viewModel communicate with the coordinator by this delegate
    weak var delegate: TransactionDetailViewModelDelegate?

    // MARK: Private properties

    /// Transaction model
    private let model: TransactionModel

    /// Transaction manager
    private let imageDownloader: ImageDownloaderServiceInterface

    /// TransactionDetailViewModel init
    /// - Parameters:
    ///   - model: Transaction model to display
    ///   - manager: Transaction manager
    init(model: TransactionModel, imageDownloader: ImageDownloaderServiceInterface) {
        self.model = model
        self.imageDownloader = imageDownloader

        self.priceTitle = NumberFormatter.formatPrice(price: model.amount.value,
                                                      currency: model.amount.currency.iso3) ?? ""
        self.subTitle = model.name
        self.dateTitle = DateFormatter.fullDateFormatter.string(from: model.date).capitalizedSentence

        self.imageViewModel = TransactionImageViewModel(transaction: model,
                                                        imageDownloader: self.imageDownloader)
    }

    /// This method is called by the viewController when the user did tap on the back button
    func userDidTapOnBackButton() {
        self.delegate?.detailViewModelUserDidTapOnBackButton(self)
    }

}

// MARK: - TransactionDetailViewModelDelegate

protocol TransactionDetailViewModelDelegate: AnyObject {
    func detailViewModelUserDidTapOnBackButton(_ viewModel: TransactionDetailViewModel)
}

// MARK: - TransactionDetailViewModelInterface

protocol TransactionDetailViewModelInterface {

    var imageViewModel: TransactionImageViewModelInterface { get }

    var priceTitle: String { get }
    var subTitle: String { get }

    var dateTitle: String { get }

    func userDidTapOnBackButton()

}
