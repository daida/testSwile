//
//  InfoSectionView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

class DetailTransactionInfoView: UIView {

    private let priceTitleLabel = SWKit.SWLabel(style: .bigTitle)

    private let nameTitle = SWKit.SWLabel(style: .impactTitle)

    private let dateTitle = SWKit.SWLabel(style: .subTitle)

    func setup() {

        self.priceTitleLabel.textAlignment = .center
        self.nameTitle.textAlignment = .center
        self.dateTitle.textAlignment = .center
        
        self.addSubview(self.priceTitleLabel)
        self.addSubview(self.nameTitle)
        self.addSubview(self.dateTitle)

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
            make.top.equalTo(self.nameTitle.snp.bottom).offset(4)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

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
