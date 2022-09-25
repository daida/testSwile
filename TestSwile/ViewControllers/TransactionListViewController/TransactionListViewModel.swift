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

    var transactionModel: [DateSectionInterface] = []

    var toInsert = CurrentValueSubject<IndexSet?, Never>(nil)

    var shouldReloadList = CurrentValueSubject<Bool, Never>(false)

    let alertModel = CurrentValueSubject<AlertModel?, Never>(nil)

    private var toAddElement: [DateSection]?

    private var originalTransactionsModels: [DateSection] = [] {
        didSet {
            self.transactionModel = self.originalTransactionsModels.compactMap { $0 as DateSectionInterface }
        }
    }

    private var refreshTask: Task<Void, Error>?

    init(manager: TransactionManagerInterface) {
        self.manager = manager
    }


    func userDidReachTheEndOfTheList() {
        if let toAddElement = toAddElement {

            let lastCount = self.originalTransactionsModels.count

            self.originalTransactionsModels.append(contentsOf: toAddElement)

            let indexSet = NSMutableIndexSet()

            for element in toAddElement.enumerated() {
                indexSet.add(element.offset + (lastCount))
            }

        	let dest = IndexSet(indexSet)

            refreshTask?.cancel()

            self.refreshTask = Task {
                try await Task.sleep(nanoseconds: UInt64(1.0) * NSEC_PER_SEC)
                try Task.checkCancellation()
                self.toInsert.value = dest
            }

        }
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

                self.toAddElement = self.originalTransactionsModels
                self.shouldReloadList.value = true

            } catch {

                let title = NSLocalizedString("error.title", comment: "")
                let subtitle: String


                if let mangerError = error as? TransactionManagerError {
                    subtitle = mangerError.text
                } else {
                    subtitle = NSLocalizedString("error.unknow", comment: "")
                }


                let retry = AlertModel.ButtonAction(name: NSLocalizedString("error.retry", comment: "")) { [weak self] in
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
    var transactionModel: [DateSectionInterface] { get }
    var alertModel: CurrentValueSubject<AlertModel?, Never> { get }
    func userDidReachTheEndOfTheList()
    func userDidTapOnElementAtIndexPath(indexPath: IndexPath)
    var toInsert: CurrentValueSubject<IndexSet?, Never> { get }
    var shouldReloadList: CurrentValueSubject<Bool, Never> { get }

}

protocol DateSectionInterface {
    var name: String { get }
    var transactions: [TransactionListCellViewModelInterface] { get }

}

struct DateSection: DateSectionInterface {

    let name: String
    let id: String
    let sectionDate: Date

    var orignalModelTransactions: [TransactionModel]

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
