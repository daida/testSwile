//
//  FinanceCoordinator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class TransactionCoordinator: Coordinator {

    var child: [Coordinator] = []

    var animator: UINavigationControllerDelegate?

    private let financeManager: TransactionManagerInterface
    private let viewControllerFactory: ViewControllerFactoryInterface

    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController(),
         financeManager: TransactionManagerInterface,
         viewControllerFactory: ViewControllerFactoryInterface) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.financeManager = financeManager
    }

    func start() {
        self.displayList()
    }

    func displayList() {
        self.animator = self.viewControllerFactory.generateAnimator()
        self.navigationController.delegate = self.animator
        let viewModel = TransactionListViewModel(manager: self.financeManager)
        viewModel.delegate = self
        let vc = self.viewControllerFactory.generateTransactionViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([vc], animated: false)
    }

    func displayDetail(transaction: TransactionModel) {
        let viewModel = TransactionDetailViewModel(model: transaction, manager: self.financeManager)
        let vc = self.viewControllerFactory.generateTransactionDetailViewController(viewModel: viewModel)
        viewModel.delegate = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func stop() {

    }
}

extension TransactionCoordinator: TransactionListViewModelDelegate {
    func transactionListViewModel(_ viewModel: TransactionListViewModel, userDidTapOnTransaction transaction: TransactionModel) {
        self.displayDetail(transaction: transaction)
    }
}

extension TransactionCoordinator: TransactionDetailViewModelDelegate {
    func detailViewModelUserDidTapOnBackButton(_ viewModel: TransactionDetailViewModel) {
        self.navigationController.popViewController(animated: true)
    }
}
