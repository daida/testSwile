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

    init(viewModel: TransactionListViewModelInterface, tableView: UITableView) {
        self.viewModel = viewModel
        self.tableView = tableView
        super.init()
        self.setupTableView()
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
        return self.viewModel.transactionModel.value[section].transactions.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.transactionModel.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionListCell.identifier, for: indexPath)
        guard let castedCell = cell as? TransactionListCell else { return cell }

        let model = self.viewModel.transactionModel.value[indexPath.section].transactions[indexPath.item]

        castedCell.configure(viewModel: model)

        return castedCell
    }

}

extension TransactionListTableViewManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let dest = MonthViewCell()
        dest.configure(month: self.viewModel.transactionModel.value[section].name)
        return dest
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
