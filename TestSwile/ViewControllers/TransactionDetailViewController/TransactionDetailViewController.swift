//
//  FinanceDetailViewController.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

class TransactionDetailViewController: UIViewController {

    private let viewModel: TransactionDetailViewModelInterface

    init(viewModel: TransactionDetailViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
