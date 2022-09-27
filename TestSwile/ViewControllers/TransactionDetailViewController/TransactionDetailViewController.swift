//
//  FinanceDetailViewController.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - TransactionDetailViewController

/// Display details of the Transaction
class TransactionDetailViewController: UIViewController, TransactionDetailAnimatorInterface {

    // MARK: Public properties

    /// Header view, it the same contain in the Transaction list cell
    let header = TransactionImageView()

    // MARK: Private properties

    /// Describe how to display Transaction detail and handle user interaction
    private let viewModel: TransactionDetailViewModelInterface

    /// Display back button
    private let backButton = SWKit.Button.SWBackButton()

    /// Display Transaction details informations
    private let detailView: DetailTransactionInfoView

    /// Display Tranaction actions
    private let detailAction = DetailActionView()

    /// This view provide a big touch zone around the back button to be sure
    /// to catch the back user press
    private let backTouchZone = UIView()

    // MARK: Private methods

    /// Setup view layout
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

    // MARK: Public method

    /// This method is call during the transition process
    /// It hide some view and set some transform in order to animate them later
    func prepareForAnimation() {
        self.backButton.alpha = 0
        self.header.isHidden = true
        self.detailView.alpha = 0
        self.detailAction.alpha = 0

        self.detailView.transform = CGAffineTransform(translationX: 0, y: 20)
        self.detailAction.transform = CGAffineTransform(translationX: 0, y: 20)
    }

    /// This method is called during the transition process
    /// It should hide all view and set a translation transform to the detail view
    func startHideAnimation() {
        self.header.isHidden = true
        self.detailView.alpha = 0
        self.detailView.transform = CGAffineTransform(translationX: 0, y: 20)
        self.detailAction.alpha = 0
        self.backButton.alpha = 0
    }

    /// This methods is called at the end of the transition process to display the "real" header (not the animate view)
    func displayHeader() {
        self.header.alpha = 0
        self.header.isHidden = false
        self.header.alpha = 1
    }

    /// This method will generate a header identical to the detail view header
    /// usefull to perform the transition to the list
    /// - Returns: a new header configured as the detail view header
    func generateHeader() -> TransactionImageView {
        let dest = TransactionImageView()
        dest.configure(viewModel: self.viewModel.imageViewModel)
        dest.activateBackgroundAlpha()
        dest.enableBigMode()
        dest.frame = self.header.frame
        return dest
    }

    /// Reveal back button, detail view, and set the detail view transform to identity
    /// This method is called during the transition process just after the moving cell sequence
    func firstAnimDone() {
        self.backButton.alpha = 1
        self.detailView.alpha = 1
        self.detailView.transform = .identity
    }

    /// This method Is called during the list to detail transition and reveal the detail view and set
    /// the detail action transform to identity
    func secondAnimDone() {
        self.detailAction.alpha = 1
        self.detailAction.transform = .identity
    }

    // MARK: Private methods

    /// Setup view hierarchy, layout, user action
    /// Accessibily identifier
    private func setup() {
        self.view.accessibilityIdentifier = "Transaction Detail"
        self.view.backgroundColor = SWKit.Colors.backgroundColor
        self.view.addSubview(self.header)
        self.view.addSubview(self.backTouchZone)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.detailView)
        self.view.addSubview(self.detailAction)
        self.setupLayout()
        self.header.activateBackgroundAlpha()
        self.header.enableBigMode()

        self.backButton.addTarget(self, action: #selector(userDidTapOnBackButton(button: )), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapOnBackButton(button:)))

        self.backTouchZone.addGestureRecognizer(tapGesture)

    }

    /// This methods is called when the user tap on the Back view zone
    /// - Parameter gesture: tap gesturre
    @objc private func userDidTapBackZone(_ gesture: UITapGestureRecognizer) {
        self.viewModel.userDidTapOnBackButton()
    }

    /// This method is called when the user tap on back button
    /// - Parameter button: back button
    @objc private func userDidTapOnBackButton(button: UIButton) {
        self.viewModel.userDidTapOnBackButton()
    }

    // MARK: Init

    /// TransactionDetailViewController init
    /// - Parameter viewModel: Describe how to display transaction detail and handle user interaction
    init(viewModel: TransactionDetailViewModelInterface) {
        self.viewModel = viewModel
        self.header.configure(viewModel: viewModel.imageViewModel)
        self.detailView = DetailTransactionInfoView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.setup()
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
