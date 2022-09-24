//
//  DetailActionViewItem.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 24/09/2022.
//

import Foundation
import UIKit

class DetailActionViewItem: UIView {

    private let actionTitle:SWKit.SWLabel = {
        let dest = SWKit.SWLabel(style: .actionTitle)
        dest.text = "Changer\nde compte"
        dest.numberOfLines = 2
        dest.textAlignment = .right
        return dest
    }()

    private let backGroundImageView: UIView = {
        let dest = UIView()
        dest.layer.cornerRadius = 12
        dest.layer.borderWidth = 1
        return dest
    }()

    private let separatorView: UIView = {
        let dest = UIView()
        dest.backgroundColor = SWKit.Colors.disabledColor
        return dest
    }()

    private let imageView: UIImageView = {
        let dest = UIImageView()
        dest.contentMode = .scaleAspectFit
        return dest
    }()

    private let title = SWKit.SWLabel(style: .title)

    private let mode: Mode

    func setupLayout() {

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

    func setupView() {
        self.addSubview(self.backGroundImageView)
        self.backGroundImageView.addSubview(self.imageView)
        self.addSubview(self.title)
        self.addSubview(self.separatorView)
        self.addSubview(self.actionTitle)
    }

    func setupModel() {
        self.title.text = mode.text
        self.backGroundImageView.backgroundColor = mode.imageBackgroundColor
        self.backGroundImageView.layer.borderColor = mode.imageBackgroundBorderColor.cgColor
        self.imageView.image = mode.icon
        self.separatorView.isHidden = !mode.shouldDisplaySeparator
        self.actionTitle.isHidden = !mode.shouldDisplayAccountSwitch
    }

    func setup() {
        self.setupView()
        self.setupLayout()
        self.setupModel()
    }

    init(mode: Mode) {
        self.mode = mode
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension DetailActionViewItem {

    enum Mode: CaseIterable {

        case titreResto
        case additionShare
        case like
        case reportAProblem

        var imageBackgroundColor: UIColor {
            switch self {
            case .titreResto: return SWKit.Colors.mealVocherColor
            case .additionShare: return SWKit.Colors.disabledColor
            case .like:  return SWKit.Colors.disabledColor
            case .reportAProblem: return SWKit.Colors.disabledColor
            }
        }

        var imageBackgroundBorderColor: UIColor {
            switch self {
            case .titreResto: return SWKit.Colors.mealVocherBorderColor
            case .additionShare: return SWKit.Colors.disabledBorderColor
            case .like:  return SWKit.Colors.disabledBorderColor
            case .reportAProblem: return SWKit.Colors.disabledBorderColor
            }
        }
        

        var icon: UIImage? {
            switch self {
            case .titreResto: return UIImage(named: "meal_voucher")
            case .additionShare: return UIImage(named: "share")
            case .like: return UIImage(named: "love")
            case .reportAProblem: return UIImage(named: "question")
            }
        }

        var text: String {
            switch self {
            case .titreResto: return "Titres-resto"
            case .additionShare: return "Partage d’addition"
            case .like: return "Aimer"
            case .reportAProblem: return "Signaler un problème"
            }
        }

        var shouldDisplayAccountSwitch: Bool {
            switch self {
            case .titreResto: return true
            case .additionShare: return false
            case .like: return false
            case .reportAProblem: return false
            }
        }

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
