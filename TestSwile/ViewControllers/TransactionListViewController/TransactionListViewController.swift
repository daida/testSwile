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

    var imageViewFrame: CGRect? {
        if let imagFrame = self.tableViewManager.imageViewFrame {
    		let dest = self.tableView.convert(imagFrame, to: self.view)            
            return dest
        } else {
            return nil
        }
    }

    var viewToAnimate: TransactionImageView? {
        return self.tableViewManager.viewToAnimate
    }

    func hideAnimatedImage() {
        self.tableViewManager.hideAnimatedImage()
    }

    init(viewModel: TransactionListViewModelInterface) {
        self.viewModel = viewModel
        self.tableViewManager = TransactionListTableViewManager(viewModel: self.viewModel,
                                                                tableView: self.tableView)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    func setupView() {
      //  self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.spinner)
    }

    func setupLayout() {

//        self.titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(self.view).offset(63)
//            make.leading.equalTo(self.view).offset(20)
//        }

        self.tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)

//            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
        }

        self.spinner.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
    }

    func revealHiddenCell() {
        self.tableViewManager.revealHiddenCell()
    }

    func setupViewModel() {
        
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

    func setup() {
        self.setupView()
        self.setupLayout()
        self.setupViewModel()
        self.view.backgroundColor = SWKit.Colors.backgroundColor
        self.title = NSLocalizedString("list.title", comment: "")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
