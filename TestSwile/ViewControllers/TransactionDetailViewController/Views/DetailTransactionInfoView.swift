//
//  InfoSectionView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

// MARK: - DetailTransactionInfoView

/// Display the Transaction price, date and name on the Detail view
class DetailTransactionInfoView: UIView {

    // MARK: Private properties

    /// Display the transaction price
    private let priceTitleLabel = SWKit.SWLabel(style: .bigTitle)

    /// Displat the transaction name
    private let nameTitle = SWKit.SWLabel(style: .impactTitle)

    /// Display the transaction date
    private let dateTitle = SWKit.SWLabel(style: .subTitle)

    /// Setup view hierarchy and layout
    private func setup() {

        self.priceTitleLabel.textAlignment = .center
        self.nameTitle.textAlignment = .center
        self.dateTitle.textAlignment = .center
        
        self.addSubview(self.priceTitleLabel)
        self.addSubview(self.nameTitle)
        self.addSubview(self.dateTitle)

        self.priceTitleLabel.accessibilityIdentifier = "Detail Price"
        self.nameTitle.accessibilityIdentifier = "Detail Name"
        self.dateTitle.accessibilityIdentifier = "Detail Date"

        self.priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.nameTitle.snp.makeConstraints { make in
            make.top.equalTo(self.priceTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }

        self.dateTitle.snp.makeConstraints { make in
            make.top.equalTo(self.nameTitle.snp.bottom).offset(8)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    // MARK: Init

    /// DetailTransactionInfoView Init
    /// - Parameter viewModel: DetailTransactionInfoView viewModel
    init(viewModel: TransactionDetailViewModelInterface) {
        self.priceTitleLabel.text = viewModel.priceTitle
        self.nameTitle.text = viewModel.subTitle
        self.dateTitle.text = viewModel.dateTitle
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
