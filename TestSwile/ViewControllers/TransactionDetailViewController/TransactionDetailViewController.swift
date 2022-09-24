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

    private let header = TransactionImageView()

    private let backButton = SWKit.SWBackButton()

    private let detailView: DetailTransactionInfoView

    private let detailAction = DetailActionView()

    private let backTouchZone = UIView()

    private func setupLayout() {
        self.header.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.height.equalTo(224)
        }

        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalTo(self.view).offset(20)
        }

        self.backTouchZone.snp.makeConstraints { make in
            make.center.equalTo(self.backButton.snp.center)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }

        self.detailView.snp.makeConstraints { make in
            make.top.equalTo(self.header.snp.bottom).offset(24)
            make.centerX.equalTo(self.view)
        }

        self.detailAction.snp.makeConstraints { make in
            make.top.equalTo(self.detailView.snp.bottom).offset(24)
            make.leading.equalTo(self.view).offset(20)
            make.trailing.equalTo(self.view).offset(-20)
        }

    }

	private func setup() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.header)
        self.view.addSubview(self.backTouchZone)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.detailView)
        self.view.addSubview(self.detailAction)
        self.setupLayout()
        self.header.enableBigMode()

        self.backButton.addTarget(self, action: #selector(userDidTapOnBackButton(button: )), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapOnBackButton(button:)))

        self.backTouchZone.addGestureRecognizer(tapGesture)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc func userDidTapBackZone(_ gesture: UITapGestureRecognizer) {
        self.viewModel.userDidTapOnBackButton()
    }

    @objc func userDidTapOnBackButton(button: UIButton) {
        self.viewModel.userDidTapOnBackButton()
    }

    init(viewModel: TransactionDetailViewModelInterface) {
        self.viewModel = viewModel
        self.header.configure(viewModel: viewModel.imageViewModel)
        self.detailView = DetailTransactionInfoView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
