//
//  MonthCell.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 22/09/2022.
//

import Foundation
import UIKit
import SnapKit

class MonthViewCell: UITableViewHeaderFooterView {

    static let identifier = "MonthViewCell"

    private let monthLabel = SWKit.SWLabel(style: .subTitle)

    func setupLayout() {
        self.monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }

    }

    func setupView() {
        self.contentView.addSubview(self.monthLabel)
    }

    func setup() {
        self.setupView()
        self.setupLayout()
    }


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }

    func configure(month: String) {
        self.monthLabel.text = month
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
