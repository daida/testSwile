//
//  TransactionListViewController.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit
import Combine

// MARK: - TransactionListViewController

/// Display all transaction in a scrollable list
class TransactionListViewController: UIViewController {

    // MARK: Private properties

    /// Handle user interaction and describe how to display the viewController
    private let viewModel: TransactionListViewModelInterface

    /// Handle tableView opperation (registerCell, dataSource and delegate)
    private let tableViewManager: TransactionListTableViewManager

    /// Store cancellables from viewModel Combien observable property (CurrentValueSubject)
    private var cancellables = Set<AnyCancellable>()

    /// Transaction list tableView
    private let tableView = UITableView()

    /// This spinner view is displayed during the data request
    private let spinner = UIActivityIndicatorView()

    // MARK: Public properties

    /// Return the selected transaction image rect in TransactionListViewController coordinate
    var imageViewFrame: CGRect? {
        if let imagFrame = self.tableViewManager.imageViewFrame {
    		let dest = self.tableView.convert(imagFrame, to: self.view)            
            return dest
        } else {
            return nil
        }
    }

    /// Return the view to animate during the transition animation
    var viewToAnimate: TransactionImageView? {
        return self.tableViewManager.viewToAnimate
    }

    /// Hide the selected transaction image
    func hideAnimatedImage() {
        self.tableViewManager.hideAnimatedImage()
    }

	// MARK: Init

    /// TransactionListViewController init
    /// - Parameter viewModel: Handle user interaction and describe how to display the viewController
    init(viewModel: TransactionListViewModelInterface) {
        self.viewModel = viewModel
        self.tableViewManager = TransactionListTableViewManager(viewModel: self.viewModel,
                                                                tableView: self.tableView)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    /// Setup view hierarchy
    private func setupView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.spinner)
    }

    /// Setup layout
    private func setupLayout() {

        self.tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }

        self.spinner.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }

    /// Setup view model subscribe to viewModel observable property
    /// All observable property are subscribe on the DispatchQue Main
    /// in order to perform UI modification
    private func setupViewModel() {
        
        self.viewModel.shouldReloadList.receive(on: DispatchQueue.main).sink { [weak self] shoulReloadList in
            guard let self = self else { return }
            if shoulReloadList == true {
                self.tableView.reloadData()
            }
        }.store(in: &self.cancellables)

        self.viewModel.toInsert.receive(on: DispatchQueue.main).sink { [weak self] indexSet in
            guard let self = self else { return }
            if let indexSet {
                self.tableView.beginUpdates()
                self.tableView.insertSections(indexSet, with: .none)
                self.tableView.endUpdates()
            }
        }.store(in: &self.cancellables)

        self.viewModel.shouldDisplaySpinner.receive(on: DispatchQueue.main).sink { [weak self] shouldDisplaySpinner in
            guard let self = self else { return }
            shouldDisplaySpinner == true ? self.spinner.startAnimating() : self.spinner.stopAnimating()

            if shouldDisplaySpinner == false {
                self.tableView.alpha = 0.0

                UIView.animate(withDuration: 0.35) { [weak self] in
                    self?.tableView.alpha = 1.0
                }
            }

        }.store(in: &self.cancellables)

        self.viewModel.alertModel.receive(on: DispatchQueue.main).sink { [weak self] alertModel in
            guard let alertModel = alertModel else { return }
            let alertController = UIAlertController(alertModel: alertModel)
            self?.present(alertController, animated: true)
        }.store(in: &self.cancellables)

    }

    /// Setup view hierarchy, layout, viewModel, and set the navigationControllet title
    private func setup() {
        self.setupView()
        self.setupLayout()
        self.setupViewModel()
        self.view.backgroundColor = SWKit.Colors.backgroundColor
        self.title = NSLocalizedString("list.title", comment: "")
    }

    // MARK: Public methods

    /// Reveal the selected transaction image (used during the transition animation)
    func revealHiddenCell() {
        self.tableViewManager.revealHiddenCell()
    }

    // MARK: UIViewController override

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

}
