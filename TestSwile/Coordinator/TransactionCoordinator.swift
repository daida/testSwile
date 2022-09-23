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
        let viewModel = TransactionListViewModel(manager: self.financeManager)
        let vc = self.viewControllerFactory.generateTransactionViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([vc], animated: false)
    }

    func stop() {

    }

}
