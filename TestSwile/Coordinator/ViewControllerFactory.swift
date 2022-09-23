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

}


protocol ViewControllerFactoryInterface {

    func generateTransactionViewController(viewModel: TransactionListViewModelInterface) -> UIViewController

    func generateTransactionDetailViewController(viewModel: TransactionDetailViewModelInterface) -> UIViewController
}
