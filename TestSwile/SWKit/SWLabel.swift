//
//  SWLabel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import UIKit

extension SWKit {

    // MARK: - SWLabel

    /// App Label Can be used with 5 different styles
    /// Each will set font and color
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

}
