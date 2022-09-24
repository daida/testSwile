//
//  SWKit.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit

struct SWKit {

    static func setup() {
        let largeAttributes = [NSAttributedString.Key.font: UIFont(name: "Segma-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34),
                          NSAttributedString.Key.foregroundColor: SWKit.Colors.titleColor]

        let smallAttributes = [NSAttributedString.Key.font: UIFont(name: "Segma-Bold", size: 24) ?? UIFont.systemFont(ofSize: 24),
                          NSAttributedString.Key.foregroundColor: SWKit.Colors.titleColor]

        UINavigationBar.appearance().largeTitleTextAttributes = largeAttributes
        UINavigationBar.appearance().titleTextAttributes = smallAttributes
    }

    class SWBackButton: UIButton {

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setImage(UIImage(named: "backIcon"), for: UIControl.State.normal)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    class SWLabel: UILabel {

        private let style: Style

        enum Style {
            case bigTitle
            case title
            case subTitle

            case actionTitle

            case impactTitle
        }

        init(style: Style) {
            self.style = style
            super.init(frame: .zero)
            switch style {
            case .title:
                self.font = UIFont(name: "Segma-Medium", size: 15)
                self.textColor = SWKit.Colors.titleColor
            case .subTitle:
                self.textColor = SWKit.Colors.subTitleColor
                self.font = UIFont(name: "Segma-Medium", size: 12)
            case .bigTitle:
                self.font = UIFont(name: "Segma-Bold", size: 34)
                self.textColor = SWKit.Colors.titleColor

            case .impactTitle:
                self.font = UIFont(name: "Segma-SemiBold", size: 13)
                self.textColor = SWKit.Colors.titleColor

            case .actionTitle:
                self.font = UIFont(name: "Segma-SemiBold", size: 12)
                self.textColor = SWKit.Colors.actionTitleColor

            }

            
        }

        override var text: String? {
            get {
                self.attributedText?.string
            } set {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.11
                paragraphStyle.lineBreakMode = .byTruncatingTail
                self.attributedText = NSMutableAttributedString(string: newValue ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            }
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

    struct Colors {

        static let titleColor = UIColor(red: 0.114, green: 0.067, blue: 0.282, alpha: 1)

        static let subTitleColor = UIColor(red: 0.569, green: 0.545, blue: 0.651, alpha: 1)

        static let donationColor = UIColor.white
        static let donationBorderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)

        static let mealVocherColor = UIColor(red: 1, green: 0.922, blue: 0.831, alpha: 1)
        static let mealVocherBorderColor = UIColor(red: 0.992, green: 0.609, blue: 0.157, alpha: 0.06)

        static let giftColor = UIColor(red: 0.996, green: 0.878, blue: 0.941, alpha: 1)
        static let giftBorderColor = UIColor(red: 0.988, green: 0.388, blue: 0.714, alpha: 0.06)

        static let mobilityColor = UIColor(red: 0.996, green: 0.878, blue: 0.882, alpha: 1)
        static let mobilityBorderColor = UIColor(red: 0.988, green: 0.388, blue: 0.42, alpha: 0.06)

        static let paymentColor = UIColor.white
        static let paymentBorderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)

        static let positivePriceTextColor = UIColor(red: 0.388, green: 0.247, blue: 0.827, alpha: 1)

        static let positivePriceTextBackgroundColor = UIColor(red: 0.902, green: 0.878, blue: 0.973, alpha: 1)

        static let actionTitleColor = UIColor(red: 0.388, green: 0.247, blue: 0.827, alpha: 1)

        static let disabledColor = UIColor(red: 0.965, green: 0.965, blue: 0.973, alpha: 1)
        static let disabledBorderColor = UIColor(red: 0.933, green: 0.929, blue: 0.945, alpha: 1)

    }
}
