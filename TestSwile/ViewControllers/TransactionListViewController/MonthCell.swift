//
//  MonthCell.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 22/09/2022.
//

import Foundation
import UIKit
import SnapKit

// MARK: - MonthViewCell

/// Display month information, used as section cell
class MonthViewCell: UITableViewHeaderFooterView {

    // MARK: Public properties

    /// Cell reueuse identifier
    static let identifier = String(describing: MonthViewCell.self)

    // MARK: Private properties

    /// Display month
    private let monthLabel = SWKit.SWLabel(style: .subTitle)

    // MARK: Private methods

    /// Setup view layout
    private func setupLayout() {
        self.monthLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }

    /// Setup view  hierarchy
    private func setupView() {
        self.contentView.addSubview(self.monthLabel)
    }

    /// Setup view hierarchy and layout
    private func setup() {
        self.setupView()
        self.setupLayout()
    }

    // MARK: Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    // MARK: Public method

    /// Configure cell (called from the cellForRowAtIndexPath tableView dataSource)
    /// - Parameter month: month string to display
    func configure(month: String) {
        self.monthLabel.text = month
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
