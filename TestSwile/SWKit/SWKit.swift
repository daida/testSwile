//
//  SWKit.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 23/09/2022.
//

import Foundation
import UIKit

/// App Design System component
/// Contain all graphical ressources, label, color, image and buttons.
///
struct SWKit {

     // MARK: setup method

    /// This methods setup the naviagtionBar title and large title font and color
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

    // MARK: CategoriesIcons

    /// Describe image categoires icons
    enum CategoriesIcons: String {
        case bakery
        case burger
        case computer
        case gift
        case mealVoucher = "meal_voucher"
        case mobility
        case supermarket
        case sushi
        case train

        /// Return the corresponding UIImage
        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }

    }

}
