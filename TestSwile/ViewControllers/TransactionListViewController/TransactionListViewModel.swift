//
//  TransactionListViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import Combine

class TransactionListViewModel: TransactionListViewModelInterface {

    weak var delegate: TransactionListViewModelDelegate?

    private let manager: TransactionManagerInterface

    let shouldDisplaySpinner = CurrentValueSubject<Bool, Never>(false)

    let transactionModel = CurrentValueSubject<[DateSectionInterface], Never>([])

    let alertModel = CurrentValueSubject<AlertModel?, Never>(nil)

    private var originalTransactionsModels: [DateSection] = [] {
        didSet {
            self.transactionModel.value = self.originalTransactionsModels.compactMap { $0 as DateSectionInterface }
        }
    }

    init(manager: TransactionManagerInterface) {
        self.manager = manager
    }

    func viewDidAppear() {
        Task {
            guard self.originalTransactionsModels.isEmpty == true else { return }
            self.shouldDisplaySpinner.value = true
            do {
                let result = try await self.manager.getTransactions()

                let dest = Dictionary(grouping: result) { DateSection(date: $0.date, transactionManager: self.manager) }

                self.originalTransactionsModels = dest.compactMap { DateSection(dateSection: $0.key, transactions: $0.value, transactionManager: self.manager) }
                    .sorted { $0.sectionDate > $1.sectionDate }

            } catch {

                let title = "Error"
                let subtitle: String


                if let mangerError = error as? TransactionManagerError {
                    subtitle = mangerError.text
                } else {
                    subtitle = "Unknow error"
                }


                let retry = AlertModel.ButtonAction(name: "Retry") { [weak self] in
                    self?.viewDidAppear()
                }


                let alertModel = AlertModel(title: title, subTitle: subtitle, okAction: retry)
                self.alertModel.value = alertModel
            }
            self.shouldDisplaySpinner.value = false
        }
    }

    func userDidTapOnElementAtIndexPath(indexPath: IndexPath) {
        let model = self.originalTransactionsModels[indexPath.section].orignalModelTransactions[indexPath.item]
        self.delegate?.transactionListViewModel(self, userDidTapOnTransaction: model)
    }


}

protocol TransactionListViewModelInterface {
    func viewDidAppear()
    var shouldDisplaySpinner: CurrentValueSubject<Bool, Never> { get }
    var transactionModel:CurrentValueSubject<[DateSectionInterface], Never> { get }
    var alertModel: CurrentValueSubject<AlertModel?, Never> { get }
    
    func userDidTapOnElementAtIndexPath(indexPath: IndexPath)

}

protocol DateSectionInterface {
    var name: String { get }
    var transactions: [TransactionListCellViewModelInterface] { get }

}

struct DateSection: DateSectionInterface {

    let name: String
    let id: String
    let sectionDate: Date

    let orignalModelTransactions: [TransactionModel]

    private let transactionManager: TransactionManagerInterface

    var transactions: [TransactionListCellViewModelInterface] {
        self.orignalModelTransactions.compactMap { TransactionListCellViewModel(model: $0, manager: self.transactionManager) }
    }

    init(date: Date, transactionManager: TransactionManagerInterface) {
        self.name = DateFormatter.monthDateFormater.string(from: date).capitalized
        self.id = DateFormatter.yearAndMonthFormatter.string(from: date)
        self.sectionDate = date
        self.transactionManager = transactionManager
        self.orignalModelTransactions = []
    }

    init(dateSection: DateSection, transactions: [TransactionModel], transactionManager: TransactionManagerInterface) {
        self.transactionManager = transactionManager
        self.name = dateSection.name
        self.id = dateSection.id
        self.sectionDate = dateSection.sectionDate
        self.orignalModelTransactions = transactions
    }
}

extension DateSection: Equatable {
    static func ==(lhs: DateSection, rhs: DateSection) -> Bool {
        return lhs.id == rhs.id
    }
}

extension DateSection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

protocol TransactionListViewModelDelegate: AnyObject {
    func transactionListViewModel(_ viewModel: TransactionListViewModel, userDidTapOnTransaction: TransactionModel)
}
