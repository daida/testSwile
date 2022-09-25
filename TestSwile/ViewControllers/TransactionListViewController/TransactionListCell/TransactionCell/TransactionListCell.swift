//
//  TransactionListCell.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit
import SnapKit

class TransactionListCell: UITableViewCell {

    static let identifier = "TransactionListCell"

    private var viewModel: TransactionListCellViewModelInterface?

    private let titleLabel = SWKit.SWLabel(style: .title)

    private let subTitleLabel = SWKit.SWLabel(style: .subTitle)

    private let transactionImageView = TransactionImageView()

    private let priceView: PriceView = PriceView()

    private let textView = UIView()

    var imageViewFrame: CGRect {
        return self.transactionImageView.frame
    }

    func hideImageView() {
        self.transactionImageView.isHidden = true
    }

    func revealImageView() {
        self.transactionImageView.isHidden = false
    }

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

    private func setup() {
        self.setupView()
        self.setupLayout()
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: TransactionListCellViewModelInterface) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.title
        self.subTitleLabel.text = viewModel.subTitle

        self.transactionImageView.configure(viewModel: viewModel.imageViewModel)
        self.priceView.configure(text: viewModel.price, isPositivePrice: viewModel.priceIsPositive)
    }

}
