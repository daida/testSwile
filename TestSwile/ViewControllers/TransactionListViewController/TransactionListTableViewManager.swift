//
//  TransactionListTableViewManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - TransactionListTableViewManager

/// Handle TransactionListViewController tableView
class TransactionListTableViewManager: NSObject {

    // MARK: Private properties

    /// Transaction listViewModel return cell viewModel and handle user interaction
    private let viewModel: TransactionListViewModelInterface

    /// Transaction list tableView
    private let tableView: UITableView

    // MARK: Public properties

    /// Transaction ImageView frame (used fo animated transition)
    /// This frame is in tableView corrdinate
    var imageViewFrame: CGRect?

    /// TransactionImageView to animate (corresponding to user selection)
    /// This is a copy from the imageView selected cell
    var viewToAnimate: TransactionImageView?

    /// Store the user selected cell
    var lastSelectedCell: TransactionListCell?

    // MARK: Init

    /// TransactionListTableViewManager init
    /// - Parameters:
    ///   - viewModel: Transaction listViewModel return cell viewModel
    ///   and handle user selection
    ///   - tableView: TransactionList tableView
    init(viewModel: TransactionListViewModelInterface, tableView: UITableView) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        self.setupTableView()
    }

    // MARK: Public methods

    /// Reveal the last selected cell (used in the animated transition)
    func revealHiddenCell() {
        self.lastSelectedCell?.revealImageView()
        self.lastSelectedCell = nil
    }

    /// Hide the user selected cell (used in the animated transition)
    func hideAnimatedImage() {
        self.lastSelectedCell?.hideImageView()
    }

    /// Hide everything but the image in the selected cell imageView
    /// hide background and accessoryview (right small image)
    func halfReveal() {
        self.lastSelectedCell?.halfRevealImageView()
    }

    // MARK: Private methods

    /// Register cell, set dataSource and delegat and configure the TableView
    private func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(TransactionListCell.self, forCellReuseIdentifier: TransactionListCell.identifier)

        self.tableView.register(MonthViewCell.self, forHeaderFooterViewReuseIdentifier: MonthViewCell.identifier)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 72
        self.tableView.sectionHeaderTopPadding = 0
        self.tableView.accessibilityIdentifier = "Transaction List"
        self.tableView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UITableViewDataSource

extension TransactionListTableViewManager: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.transactionModel[section].transactions.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.transactionModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListCell.identifier, for: indexPath)
        guard let castedCell = cell as? TransactionListCell else { return cell }

        let model = self.viewModel.transactionModel[indexPath.section].transactions[indexPath.item]

        castedCell.configure(viewModel: model)

        return castedCell
    }

}

// MARK: - UITableViewDelegate

extension TransactionListTableViewManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        if let castedCell = tableView.cellForRow(at: indexPath) as? TransactionListCell {
            self.imageViewFrame = castedCell.convert(castedCell.imageViewFrame, to: self.tableView)
            self.viewToAnimate = TransactionImageView()
            self.viewToAnimate?.configure(viewModel: self.viewModel.transactionModel[indexPath.section].transactions[indexPath.item].imageViewModel)
            self.lastSelectedCell = castedCell

        }

        self.viewModel.userDidTapOnElementAtIndexPath(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dest = tableView.dequeueReusableHeaderFooterView(withIdentifier: MonthViewCell.identifier)
        guard let castedCell = dest as? MonthViewCell else { return dest }
        castedCell.configure(month: self.viewModel.transactionModel[section].name)
        return dest
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == self.viewModel.transactionModel.count - 1 {
            if indexPath.item == self.viewModel.transactionModel[indexPath.section].transactions.count - 1 {
                self.viewModel.userDidReachTheEndOfTheList()
            }
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
}
