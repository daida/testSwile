//
//  TransactionDetailViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

class TransactionDetailViewModel: TransactionDetailViewModelInterface {

    let imageViewModel: TransactionImageViewModelInterface

    let priceTitle: String

    let subTitle: String

    let dateTitle: String

    weak var delegate: TransactionDetailViewModelDelegate?

    private let model: TransactionModel
    private let manager: TransactionManagerInterface

    init(model: TransactionModel, manager: TransactionManagerInterface) {
        self.model = model
        self.manager = manager

        self.priceTitle = NumberFormatter.formatPrice(price: model.amount.value, currency: model.amount.currency.iso3) ?? ""
        self.subTitle = model.name
        self.dateTitle = DateFormatter.fullDateFormatter.string(from: model.date).capitalizedSentence

        self.imageViewModel = TransactionImageViewModel(transaction: model, manager: self.manager)
    }

    func userDidTapOnBackButton() {
        self.delegate?.detailViewModelUserDidTapOnBackButton(self)
    }
    
}

protocol TransactionDetailViewModelDelegate: AnyObject {
    func detailViewModelUserDidTapOnBackButton(_ viewModel: TransactionDetailViewModel)
}

protocol TransactionDetailViewModelInterface {

    var imageViewModel: TransactionImageViewModelInterface { get }

    var priceTitle: String { get }
    var subTitle: String { get }

    var dateTitle: String { get }

    func userDidTapOnBackButton()

}
