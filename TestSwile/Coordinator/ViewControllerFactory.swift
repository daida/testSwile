//
//  ViewControllerFactory.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class ViewControllerFactory: ViewControllerFactoryInterface {

    func generateTransactionViewController(viewModel: TransactionListViewModelInterface) -> UIViewController {
        return TransactionListViewController(viewModel: viewModel)
   }

    func generateTransactionDetailViewController(viewModel: TransactionDetailViewModelInterface) -> UIViewController {
        return TransactionDetailViewController(viewModel: viewModel)
    }

    func generateAnimator() ->  UIViewControllerTransitioningDelegate {
        return TransitionAnimator()
    }

}


protocol ViewControllerFactoryInterface {

    func generateAnimator() ->  UIViewControllerTransitioningDelegate

    func generateTransactionViewController(viewModel: TransactionListViewModelInterface) -> UIViewController

    func generateTransactionDetailViewController(viewModel: TransactionDetailViewModelInterface) -> UIViewController
}
