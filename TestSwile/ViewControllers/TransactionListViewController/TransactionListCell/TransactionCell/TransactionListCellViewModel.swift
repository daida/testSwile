//
//  TransactionListCellViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - TransactionListCellViewModel

/// Contain transaction display (formated text and imageViewModel) cell information, 
class TransactionListCellViewModel: TransactionListCellViewModelInterface {

    // MARK: Private properties

    /// Transaction model to display
    private let model: TransactionModel

    /// manager
    private let imageDownloader: ImageDownloaderServiceInterface

    // MARK: Public properties

    /// Transaction image view model, describe image,
    /// and style for the main image and the accessory image
    let imageViewModel: TransactionImageViewModelInterface

    /// Transaction name
    let title: String

    /// Transaction subtitle (date + message) 7 Mars ・Don à l'arrondi
    let subTitle: String

    /// Transaction price with the localized currency position and the plus if it's required (+ 15 €)
    let price: String

    /// Describe if the price is positive
    let priceIsPositive: Bool

    // MARK: Init

    /// TransactionListCellViewModel init
    /// - Parameters:
    ///   - model: Transaction model to disply
    ///   - manager: manager
    init(model: TransactionModel, imageDownloader: ImageDownloaderServiceInterface) {
        self.model = model
        self.title = model.name
        self.imageDownloader = imageDownloader

        if let message = model.message {
            self.subTitle = "\(DateFormatter.shortDateFormatter.string(from: model.date))・\(message)"
        } else {
            self.subTitle = "\(DateFormatter.shortDateFormatter.string(from: model.date))"
        }

        self.price = NumberFormatter.formatPrice(price: model.amount.value, currency: model.amount.currency.iso3) ?? ""

        self.priceIsPositive = model.amount.value > 0

        self.imageViewModel = TransactionImageViewModel(transaction: model, imageDownloader: imageDownloader)
    }

}

// MARK: - TransactionListCellViewModelInterface

protocol TransactionListCellViewModelInterface {
    var title: String { get }
    var subTitle: String { get }
    var price: String { get }
    var priceIsPositive: Bool { get }

    var imageViewModel: TransactionImageViewModelInterface { get }

}
