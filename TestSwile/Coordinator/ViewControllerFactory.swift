//
//  ViewControllerFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - ViewControllerFactory

/// This class wil generate viewControllers with viewModel
class ViewControllerFactory: ViewControllerFactoryInterface {

    // MARK: Public methods

    /// Generate transaction list viewController
    /// - Parameter viewModel: Handle user interaction and describe how to display the TransactionListViewController
    /// - Returns: TransactionListViewController
    func generateTransactionViewController(viewModel: TransactionListViewModelInterface) -> UIViewController {
        return TransactionListViewController(viewModel: viewModel)
   }

    /// Generate Transaction detail viewController
    /// - Parameter viewModel: Describe how to display transaction
    ///  detail and handle user interaction
    /// - Returns: TransactionDetailViewController
    func generateTransactionDetailViewController(viewModel: TransactionDetailViewModelInterface) -> UIViewController {
        return TransactionDetailViewController(viewModel: viewModel)
    }

    /// Generate a UIViewControllerTransitioningDelegate
    /// animated the transition between the list to detail transaction, and the inverse animation
    /// This UIViewControllerTransitioningDelegate should be set on the list viewController
    /// - Returns: list to detail UIViewControllerTransitioningDelegate should be set on the transitioningDelegate list property 
    func generateAnimator() ->  UIViewControllerTransitioningDelegate {
        return TransitionAnimator()
    }
}

// MARK: - ViewControllerFactoryInterface


protocol ViewControllerFactoryInterface {

    func generateAnimator() ->  UIViewControllerTransitioningDelegate

    func generateTransactionViewController(viewModel: TransactionListViewModelInterface) -> UIViewController

    func generateTransactionDetailViewController(viewModel: TransactionDetailViewModelInterface) -> UIViewController
}
