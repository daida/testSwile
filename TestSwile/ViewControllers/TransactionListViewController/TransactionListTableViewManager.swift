//
//  TransactionListTableViewManager.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class TransactionListTableViewManager: NSObject {

    private let viewModel: TransactionListViewModelInterface

    private let tableView: UITableView


    var imageViewFrame: CGRect?
    var viewToAnimate: TransactionImageView?

    var lastSelectedCell: TransactionListCell?


    init(viewModel: TransactionListViewModelInterface, tableView: UITableView) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        self.setupTableView()
    }

    func revealHiddenCell() {
        self.lastSelectedCell?.revealImageView()
        self.lastSelectedCell = nil
    }

    func hideAnimatedImage() {
        self.lastSelectedCell?.hideImageView()
    }

    private func setupTableView() {
        self.tableView.separatorStyle = .none
        self.tableView.register(TransactionListCell.self, forCellReuseIdentifier: TransactionListCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 72
        self.tableView.sectionHeaderTopPadding = 0
    }
}

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
		let dest = MonthViewCell()
        dest.configure(month: self.viewModel.transactionModel[section].name)
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
