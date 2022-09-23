//
//  TransactionListCellViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

class TransactionListCellViewModel: TransactionListCellViewModelInterface {

    private let model: TransactionModel
    private let manager: TransactionManagerInterface
    let imageViewModel: TransactionImageViewModelInterface

    let title: String
    let subTitle: String
    let price: String
    let priceIsPositive: Bool

	private static func formatPrice(price: Float, currency: String) -> String? {
    	let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .currency
        numberFormater.currencyCode = currency
        numberFormater.positivePrefix = "+"

        if price.truncatingRemainder(dividingBy: 1) == 0 {
            numberFormater.maximumFractionDigits = 0
        }

        numberFormater.locale = Locale(identifier: "fr_FR")
        return numberFormater.string(from: NSNumber(value: price))
    }

    init(model: TransactionModel, manager: TransactionManagerInterface) {
        self.model = model
        self.title = model.name
        self.manager = manager

        if let message = model.message {
            self.subTitle = "\(DateFormatter.shortDateFormatter.string(from: model.date))・\(message)"
        } else {
            self.subTitle = "\(DateFormatter.shortDateFormatter.string(from: model.date))"
        }

        self.price = TransactionListCellViewModel.formatPrice(price: model.amount.value, currency: model.amount.currency.iso3) ?? ""

        self.priceIsPositive = model.amount.value > 0

        self.imageViewModel = TransactionImageViewModel(transaction: model, manager: manager)
    }

}

protocol TransactionListCellViewModelInterface {
    var title: String { get }
    var subTitle: String { get }
    var price: String { get }
    var priceIsPositive: Bool { get }

    var imageViewModel: TransactionImageViewModelInterface { get }

}
