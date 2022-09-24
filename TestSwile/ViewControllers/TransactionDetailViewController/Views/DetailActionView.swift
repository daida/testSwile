//
//  DetailActionView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

class DetailActionView: UIView {

    private let stackView: UIStackView = {
        let dest = UIStackView()
        dest.axis = .vertical
        dest.spacing = 0
        dest.distribution = .equalSpacing
        return dest
    }()

    private func setupLayout() {
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    private func setupView() {
    	self.addSubview(self.stackView)
    }

	private func setup() {
        self.setupView()
        self.setupLayout()

        DetailActionViewItem.Mode.allCases
            .compactMap { DetailActionViewItem(mode: $0) }
            .forEach { self.stackView.addArrangedSubview($0) }

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
