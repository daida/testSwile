//
//  TransactionListViewController.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit
import Combine

class TransactionListViewController: UIViewController {

    private let viewModel: TransactionListViewModelInterface
    private let tableViewManager: TransactionListTableViewManager

    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()

    private let spinner = UIActivityIndicatorView()

    init(viewModel: TransactionListViewModelInterface) {
        self.viewModel = viewModel
        self.tableViewManager = TransactionListTableViewManager(viewModel: self.viewModel, tableView: self.tableView)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    func setupView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.spinner)
    }

    func setupLayout() {

        self.tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)

            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)
        }

        self.spinner.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }

    func setupViewModel() {
        self.viewModel.transactionModel.receive(on: DispatchQueue.main).sink { [weak self] data in
            guard let self = self else { return }
            if data.isEmpty == false {
                self.tableView.alpha = 0.0
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.35) {
                    self.tableView.alpha = 1.0
                }
            }

        }.store(in: &self.cancellables)

        self.viewModel.shouldDisplaySpinner.receive(on: DispatchQueue.main).sink { [weak self] shouldDisplaySpinner in
            guard let self = self else { return }
            shouldDisplaySpinner == true ? self.spinner.startAnimating() : self.spinner.stopAnimating()
        }.store(in: &self.cancellables)

        self.viewModel.alertModel.receive(on: DispatchQueue.main).sink { [weak self] alertModel in
            guard let alertModel = alertModel else { return }
            let alertController = UIAlertController(alertModel: alertModel)
            self?.present(alertController, animated: true)
        }.store(in: &self.cancellables)

    }

    func setup() {
        self.setupView()
        self.setupLayout()
        self.setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.white
        self.title = "Titre-resto"
        self.viewModel.viewDidAppear()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
