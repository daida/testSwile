//
//  FinanceCoordinator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - TransactionCoordinator

/// Main App Coordinator
/// This corrdinator will handle user flow
/// This object is NOT coupled with concrete viewController instance
/// viewControllers are retrive by the viewController factory
/// The coordinator get userInteraction events by using viewModels delegate
///
///	This is how the sequence workjs
///
/// Coordinator instanciate ViewModel, retrive ViewController from ViewController factory
///	Set viewModel delegate to self (coordinator)
///	push / present the viewController
///
class TransactionCoordinator: Coordinator {

    // MARK: Public properties

    /// Child Coordinator required by the Coordinator protocol (not used here)
    var child: [Coordinator] = []

    /// Coordinator navigationController can be injected
    var navigationController: UINavigationController

    // MARK: Pivate properties

    /// Retive transactions models
    private let transactionManager: TransactionManagerInterface

	private let imageDownloader: ImageDownloaderServiceInterface

    /// Instanciate viewController from viewModels
    private let viewControllerFactory: ViewControllerFactoryInterface

    /// ViewController UIViewControllerTransitioningDelegate
    /// will perform custom transition from list to detail controller
    /// and the inverse animation
    /// This UIViewControllerTransitioningDelegate will be set on the listViewController
    private let animator: UIViewControllerTransitioningDelegate

    // MARK: Init

    init(navigationController: UINavigationController = UINavigationController(),
         transactionManager: TransactionManagerInterface,
         imageDownloader: ImageDownloaderServiceInterface,
         viewControllerFactory: ViewControllerFactoryInterface) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.transactionManager = transactionManager
        self.animator = self.viewControllerFactory.generateAnimator()
        self.imageDownloader = imageDownloader
    }

    // MARK: Public methods

    /// Coordinator start method (required by the Coordinator protocol)
    func start() {
        self.displayList()
    }

    /// Display the transaction list
    private func displayList() {
        let viewModel = TransactionListViewModel(manager: self.transactionManager,
                                                 imageDownloader: self.imageDownloader)
        viewModel.delegate = self
        let vc = self.viewControllerFactory.generateTransactionViewController(viewModel: viewModel)
        self.navigationController.setViewControllers([vc], animated: false)
    }

    /// Display transaction detail list corresponding to user selected transaction
    /// - Parameter transaction: user selected transaction
    private func displayDetail(transaction: TransactionModel) {
        let viewModel = TransactionDetailViewModel(model: transaction,
                                                   imageDownloader: self.imageDownloader)
        let vc = self.viewControllerFactory.generateTransactionDetailViewController(viewModel: viewModel)
        vc.transitioningDelegate = self.animator
        viewModel.delegate = self
        self.navigationController.present(vc, animated: true)
    }

    /// Required by the Coordinator protocol
    func stop() {

    }
}

// MARK: - TransactionListViewModelDelegate

extension TransactionCoordinator: TransactionListViewModelDelegate {
    func transactionListViewModel(_ viewModel: TransactionListViewModel,
                                  userDidTapOnTransaction transaction: TransactionModel) {
        self.displayDetail(transaction: transaction)
    }
}

// MARK: - TransactionDetailViewModelDelegate

extension TransactionCoordinator: TransactionDetailViewModelDelegate {
    func detailViewModelUserDidTapOnBackButton(_ viewModel: TransactionDetailViewModel) {
        self.navigationController.dismiss(animated: true)
    }
}
