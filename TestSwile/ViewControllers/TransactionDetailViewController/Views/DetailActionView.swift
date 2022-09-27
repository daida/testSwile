//
//  DetailActionView.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

// MARK: - DetailActionView

/// Display user Action on the Detail View
class DetailActionView: UIView {

    // MARK: Private properties

    /// All user action view are stored in this UIStackView
    private let stackView: UIStackView = {
        let dest = UIStackView()
        dest.axis = .vertical
        dest.spacing = 0
        dest.distribution = .equalSpacing
        return dest
    }()

    /// Setup View layout
    private func setupLayout() {
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    /// Setup View hierarchy
    private func setupView() {
        self.addSubview(self.stackView)
    }

    /// setup view layout, hierarchy and populate the stackView
    /// with Detail action item view
    private func setup() {
        self.setupView()
        self.setupLayout()

        DetailActionViewItem.Mode.allCases
            .compactMap { DetailActionViewItem(mode: $0) }
            .forEach { self.stackView.addArrangedSubview($0) }

    }

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
