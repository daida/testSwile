//
//  TransactionListCell.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit
import SnapKit

// MARK: - TransactionListCell

/// Display Transaction in a list
class TransactionListCell: UITableViewCell {

    // MARK: Public property

    /// ReueseIdentifier for the UITableView register
    static let identifier = String(describing: TransactionListCell.self)

    // MARK: Private property

    /// Cell viewModel describe how to display the transaction
    private var viewModel: TransactionListCellViewModelInterface?

    /// Display transaction name
    private let titleLabel = SWKit.SWLabel(style: .title)

    /// Display transaction date and message
    private let subTitleLabel = SWKit.SWLabel(style: .subTitle)

    /// Display transaction image and accessory image (the small view in the corner)
    private let transactionImageView = TransactionImageView()

    /// Display transaction price
    private let priceView: PriceView = PriceView()

    /// Group title and subtile view in the same view in order to center them more easly
    private let textView = UIView()

    /// Return the transaction image frame, usefull in the transition animation
    var imageViewFrame: CGRect {
        return self.transactionImageView.frame
    }

    // MARK: Public methods

    /// Hide the imageView (usefull in the transition animation)
    func hideImageView() {
        self.transactionImageView.isHidden = true
    }

    /// Reveal the imageView (usefull in the transition animation)
    func revealImageView() {
        self.transactionImageView.revealImage()
    }

    /// Hal reveal image, this method will only display the category image or the remote image and will
    /// hide background and accessory view
    func halfRevealImageView() {
        self.transactionImageView.halfReveal()
    }

    // MARK: Private methods

    /// Setup view layout
    private func setupLayout() {

        self.textView.snp.makeConstraints { make in
            make.leading.equalTo(self.transactionImageView.snp.trailing).offset(16)
            make.centerY.equalTo(self.contentView)
            make.trailing.equalTo(self.contentView)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.textView)
            make.leading.equalTo(self.textView)
            make.trailing.lessThanOrEqualTo(self.priceView.snp.leading).offset(-20)
            make.height.equalTo(20)
        }

        self.subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(self.textView)
            make.height.equalTo(16)
            make.bottom.equalTo(self.textView)
            make.trailing.lessThanOrEqualTo(self.priceView.snp.leading).offset(-20)
        }

        self.transactionImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(56)
            make.height.equalTo(56)
        }

        self.priceView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
        }
    }

    /// Setup view hierarchy
    private func setupView() {

        self.transactionImageView.accessibilityIdentifier = "Cell Image"
        self.titleLabel.accessibilityIdentifier = "Cell Title"
        self.subTitleLabel.accessibilityIdentifier = "Cell SubTitle"

        self.addSubview(self.textView)

        self.addSubview(self.transactionImageView)
        self.textView.addSubview(self.titleLabel)
        self.textView.addSubview(self.subTitleLabel)

        self.textView.addSubview(self.priceView)

        self.subTitleLabel.lineBreakMode = .byTruncatingTail
    }

    /// Setup view layout and hierarchy
    private func setup() {
        self.setupView()
        self.setupLayout()
    }

    // MARK: UITableViewCell override methods

    // Those method are overrided and are empty because we don't want to change cell color on select and highlight
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    override func setSelected(_ selected: Bool, animated: Bool) {}

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public method

    /// Configure the Transaction cell with cell viewModel
    /// - Parameter viewModel: Cell viewModel describe how to display the transaction
    func configure(viewModel: TransactionListCellViewModelInterface) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.title
        self.subTitleLabel.text = viewModel.subTitle

        self.transactionImageView.configure(viewModel: viewModel.imageViewModel)
        self.priceView.configure(text: viewModel.price, isPositivePrice: viewModel.priceIsPositive)
    }

}
