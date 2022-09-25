//
//  PriceView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit
import SnapKit

class PriceView: UIView {

    private let label: SWKit.SWLabel = {
        let dest = SWKit.SWLabel(style: .title)
        dest.setContentCompressionResistancePriority(.required, for: .horizontal)
        dest.setContentHuggingPriority(.required, for: .horizontal)
        return dest
    }()

    var leadConstraint: Constraint?
    var trailingConstraint: Constraint?

    func setupLayout() {

        self.label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            self.leadConstraint =  make.leading.equalTo(self.snp.leading).offset(6).constraint
            self.trailingConstraint = make.trailing.equalTo(self.snp.trailing).offset(-6).constraint
            make.bottom.equalTo(self.snp.bottom)
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(24)
        }

    }

    func setupView() {
        self.addSubview(self.label)
        self.layer.cornerRadius = 9
    }

    func setup() {
        self.setupView()
        self.setupLayout()
    }

    func configure(text: String, isPositivePrice: Bool) {
        self.label.text = text

        if isPositivePrice == true {
            self.label.textColor = SWKit.Colors.positivePriceTextColor
            self.backgroundColor = SWKit.Colors.positivePriceTextBackgroundColor
            self.leadConstraint?.update(offset: 6)
            self.trailingConstraint?.update(offset: -6)
        } else {
            self.leadConstraint?.update(offset: 0)
            self.trailingConstraint?.update(offset: 0)
            self.backgroundColor = .clear
            self.label.textColor = SWKit.Colors.titleColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
