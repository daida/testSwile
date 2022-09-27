//
//  TransactionListViewModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import Combine

// MARK: - TransactionListViewModel

/// Handle user interaction and describe how to display the TransactionListViewController
class TransactionListViewModel: TransactionListViewModelInterface {

    // MARK: Public properties

    /// This delegate is used to communicate with the Coordinator,
    ///	this delegate object is called when the user select a transaction
    weak var delegate: TransactionListViewModelDelegate?

    /// This manager is used to fetch Transaction model from API (or from cache if there is no internet)
    private let manager: TransactionManagerInterface

    private let imageDownloader: ImageDownloaderServiceInterface

    /// Combine Observable property describe if the spinner should be displayed
    let shouldDisplaySpinner = CurrentValueSubject<Bool, Never>(false)

    /// Transaction cell view model, group in DateSection object in order to group them in section
    /// for instance DateSectionInterface march wiill contain 3 transactions
    /// This will be used to describe section / item in the tableView
    /// Transaction object is cellViewModel TransactionListCellViewModelInterface
    var transactionModel: [DateSectionInterface] = []

    /// Combine CurrentValueSubject describe sections to insert in the TableView
    var toInsert = CurrentValueSubject<IndexSet?, Never>(nil)

    /// Combine CurrentValueSubject describe if the tableView should reload
    var shouldReloadList = CurrentValueSubject<Bool, Never>(false)

    /// AlertModel, when this model is set, an AlerView is displayed with the alertModel information
    /// action handle are also hanldle in this model
    let alertModel = CurrentValueSubject<AlertModel?, Never>(nil)

    // MARK: Private properties

    /// Contain Section to add when the user reach the end of the tableView
    private var toAddElement: [DateSection]?

    /// Contain the concrete implementation of DateSection who contain original Transaction model
    /// This property is not visible by the viewController (because it's a model)
    /// When this property is set, the public property transactionModel is set with DateSectionInterface
    /// DateSectionInterface does'nt allow acces to the Model (but allow access to cellViewModel)
    private var originalTransactionsModels: [DateSection] = [] {
        didSet {
            self.transactionModel = self.originalTransactionsModels.compactMap { $0 as DateSectionInterface }
        }
    }

    // MARK: Init

    /// TransactionListViewModel init
    /// - Parameter manager: This manager is used to fetch
    ///  Transaction model from API (or from cache if there is no internet)
    init(manager: TransactionManagerInterface, imageDownloader: ImageDownloaderServiceInterface) {
        self.manager = manager
        self.imageDownloader = imageDownloader
    }

    // MARK: Public methods

    /// This method is called when the user did reach the end of the list
    /// some transactions will be add and the toInsert observable property will be set,
    /// so the viewController will add the corresponding section in the transaction tableView
    func userDidReachTheEndOfTheList() {
        
        if let toAddElement = toAddElement {

            let lastCount = self.originalTransactionsModels.count

            self.originalTransactionsModels.append(contentsOf: toAddElement)

            let indexSet = NSMutableIndexSet()

            for element in toAddElement.enumerated() {
                indexSet.add(element.offset + (lastCount))
            }

            let dest = IndexSet(indexSet)
            self.toInsert.value = dest
        }
    }

    /// This method is called from the viewDidApear viewController method
    /// it will call getTransaction method from the transaction manager, and will update viewModel observable accordingly
    /// Model will be group in DateSection object (in order to group model by month)
    func viewDidAppear() {
        Task {
            guard self.originalTransactionsModels.isEmpty == true else { return }
            self.shouldDisplaySpinner.value = true
            do {
                let result = try await self.manager.getTransactions()

                let dest = Dictionary(grouping: result) { DateSection(date: $0.date, imageDownloader: self.imageDownloader) }


                self.originalTransactionsModels = dest.compactMap { DateSection(dateSection: $0.key, transactions: $0.value, imageDownloader: self.imageDownloader) }
                    .sorted { $0.sectionDate > $1.sectionDate }

                self.toAddElement = self.originalTransactionsModels

                for _ in 0...30 {
                    self.toAddElement?.append(contentsOf: self.originalTransactionsModels)
                }

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

    /// This method is called when the user did tap on indexPath
    /// - Parameter indexPath: user indexPath selection
    func userDidTapOnElementAtIndexPath(indexPath: IndexPath) {
        let model = self.originalTransactionsModels[indexPath.section].orignalModelTransactions[indexPath.item]
        self.delegate?.transactionListViewModel(self, userDidTapOnTransaction: model)
    }

}

// MARK: - TransactionListViewModelInterface

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

// MARK: - DateSectionInterface

protocol DateSectionInterface {
    var name: String { get }
    var transactions: [TransactionListCellViewModelInterface] { get }

}

// MARK: - DateSection

/// Describle month section and contain corrsponding Transaction models
struct DateSection: DateSectionInterface {

    /// Month name
    let name: String

    /// Date section id (used for Equatable conformance)
    let id: String

    /// Section date used to sort sections
    let sectionDate: Date

    /// Concrete TransactionModel model array
    var orignalModelTransactions: [TransactionModel]

    /// manager
    private let imageDownloader: ImageDownloaderServiceInterface

    /// Public transaction cell view model
    var transactions: [TransactionListCellViewModelInterface] {
        self.orignalModelTransactions.compactMap { TransactionListCellViewModel(model: $0, imageDownloader: self.imageDownloader) }
    }

    /// DateSection init
    /// - Parameters:
    ///   - date: Section date
    ///   - transactionManager: manager
    init(date: Date, imageDownloader: ImageDownloaderServiceInterface) {
        self.name = DateFormatter.monthDateFormater.string(from: date).capitalized
        self.id = DateFormatter.yearAndMonthFormatter.string(from: date)
        self.sectionDate = date
        self.imageDownloader = imageDownloader
        self.orignalModelTransactions = []
    }

    /// DateSection init
    /// - Parameters:
    ///   - dateSection: Section date
    ///   - transactions: Month transaction (for instance march transaction models)
    ///   - transactionManager: manager
    init(dateSection: DateSection, transactions: [TransactionModel], imageDownloader: ImageDownloaderServiceInterface) {
        self.imageDownloader = imageDownloader
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

// MARK: - TransactionListViewModelDelegate

protocol TransactionListViewModelDelegate: AnyObject {
    func transactionListViewModel(_ viewModel: TransactionListViewModel, userDidTapOnTransaction: TransactionModel)
}
