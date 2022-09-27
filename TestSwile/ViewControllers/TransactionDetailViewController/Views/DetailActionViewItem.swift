//
//  DetailActionViewItem.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

// MARK: - DetailActionViewItem

/// Display individual action view
class DetailActionViewItem: UIView {

    /// Action Title view display a static label switch account
    private let actionTitle:SWKit.SWLabel = {
        let dest = SWKit.SWLabel(style: .actionTitle)
        dest.text = NSLocalizedString("detail.swich_account", comment: "")
        dest.numberOfLines = 2
        dest.textAlignment = .right
        return dest
    }()

    /// Display a circle background behind the imageView
    private let backGroundImageView: UIView = {
        let dest = UIView()
        dest.layer.cornerRadius = 12
        dest.layer.borderWidth = 1
        return dest
    }()

    /// Display a line of 1 pixel at the bottom of the view
    private let separatorView: UIView = {
        let dest = UIView()
        dest.backgroundColor = SWKit.Colors.disabledColor
        return dest
    }()

    /// Dislay the action logo view
    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        return dest
    }()

    /// Display Action title
    private let title = SWKit.SWLabel(style: .title)

    /// Store the action mode
    private let mode: Mode

    /// Setup view layout
    private func setupLayout() {

        self.snp.makeConstraints { make in
            if self.mode.shouldDisplaySeparator == true {
                make.height.equalTo(57)
            } else {
                make.height.equalTo(56)
            }
        }

        self.backGroundImageView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }

        self.imageView.snp.makeConstraints { make in
            make.center.equalTo(self.backGroundImageView)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        self.title.snp.makeConstraints { make in
            make.leading.equalTo(self.backGroundImageView.snp.trailing).offset(18)
            make.centerY.equalTo(self)
        }

        self.separatorView.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-1)
            make.height.equalTo(1)
            make.leading.equalTo(self.title)
            make.trailing.equalTo(self)
        }

        self.actionTitle.snp.makeConstraints { make in
            make.trailing.trailing.equalTo(self.snp.trailing)
            make.centerY.equalTo(self)
        }

    }

    /// Setup view hierarchy
    private func setupView() {
        self.addSubview(self.backGroundImageView)
        self.backGroundImageView.addSubview(self.imageView)
        self.addSubview(self.title)
        self.addSubview(self.separatorView)
        self.addSubview(self.actionTitle)
    }

    /// Setup viewModel
    private func setupModel() {
        self.title.text = mode.text
        self.backGroundImageView.backgroundColor = mode.imageBackgroundColor
        self.backGroundImageView.layer.borderColor = mode.imageBackgroundBorderColor.cgColor
        self.imageView.image = mode.icon
        self.separatorView.isHidden = !mode.shouldDisplaySeparator
        self.actionTitle.isHidden = !mode.shouldDisplayAccountSwitch
        self.accessibilityIdentifier = self.mode.identifier
    }

    /// Setup view hierarchy view model, and layout
    private func setup() {
        self.setupView()
        self.setupLayout()
        self.setupModel()
    }

    /// DetailActionViewItem
    /// - Parameter mode: action mode to display (titreResto, additionShare, like, reportAProblem)
    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - DetailActionViewItem

extension DetailActionViewItem {

    /// Describe Action
    enum Mode: CaseIterable {

        case titreResto
        case additionShare
        case like
        case reportAProblem

        /// Describe the action image background color
        var imageBackgroundColor: UIColor {
            switch self {
            case .titreResto: return SWKit.Colors.mealVocherColor
            case .additionShare: return SWKit.Colors.disabledColor
            case .like:  return SWKit.Colors.disabledColor
            case .reportAProblem: return SWKit.Colors.disabledColor
            }
        }

        /// Describe the action image border color
        var imageBackgroundBorderColor: UIColor {
            switch self {
            case .titreResto: return SWKit.Colors.mealVocherBorderColor
            case .additionShare: return SWKit.Colors.disabledBorderColor
            case .like:  return SWKit.Colors.disabledBorderColor
            case .reportAProblem: return SWKit.Colors.disabledBorderColor
            }
        }

        /// Describe the accessibility identifier for each action
        var identifier: String {
            switch self {
            case .titreResto: return "Detail Titre Resto"
            case .additionShare: return "Detail Addition share"
            case .like: return "Detail love"
            case .reportAProblem: return "Detail problem"
            }
        }
        

        /// Describe action image
        var icon: UIImage? {
            switch self {
            case .titreResto: return UIImage(named: "meal_voucher")
            case .additionShare: return UIImage(named: "share")
            case .like: return UIImage(named: "love")
            case .reportAProblem: return UIImage(named: "question")
            }
        }

        /// Describe text image
        var text: String {
            switch self {
            case .titreResto: return NSLocalizedString("detail.titre_resto", comment: "")
            case .additionShare: return NSLocalizedString("detail.bill.split", comment: "")
            case .like: return NSLocalizedString("detail.like", comment: "")
            case .reportAProblem: return NSLocalizedString("detail.report", comment: "")
            }
        }

        /// Describe if the static label switch account should be displayed
        var shouldDisplayAccountSwitch: Bool {
            switch self {
            case .titreResto: return true
            case .additionShare: return false
            case .like: return false
            case .reportAProblem: return false
            }
        }

        /// Describe if a separator should be dispalyed
        var shouldDisplaySeparator: Bool {
            switch self {
            case .titreResto: return true
            case .additionShare: return true
            case .like: return true
            case .reportAProblem: return false
            }
        }

    }
}
