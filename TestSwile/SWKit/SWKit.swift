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

        guard let largeFont = UIFont(name: "Segma-Bold", size: 34),
        let smallFont = UIFont(name: "Segma-SemiBold", size: 20)
        else { return }

        let largeTitleAttributes = [
            NSAttributedString.Key.foregroundColor: SWKit.Colors.titleColor,
            NSAttributedString.Key.font: largeFont
        ]

        let smallTitleAttributes = [
            NSAttributedString.Key.foregroundColor: SWKit.Colors.titleColor,
            NSAttributedString.Key.font: smallFont
        ]

        UINavigationBar.appearance().titleTextAttributes = smallTitleAttributes
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleAttributes
    }

    enum CategoriesIcons: String {
        case bakery
        case burger
        case computer
        case gift
        case meal_voucher
        case mobility
        case supermarket
        case sushi
        case train

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }

    }

}
